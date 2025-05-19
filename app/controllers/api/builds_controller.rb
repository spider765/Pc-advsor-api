class Api::BuildsController < ApplicationController
  require 'httparty'

  KLUSTER_API_ENDPOINT = "https://api.kluster.ai/v1/chat/completions".freeze

  def create
    if params[:build][:cpu].present?
      manual_build
    else
      ai_generated_build
    end
  rescue StandardError => e
    Rails.logger.error "Error in BuildsController: #{e.message}\n#{e.backtrace.join("\n")}"
    render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
  end

  private

  def manual_build
    @build = Build.new(build_params)

    if @build.save
      render json: @build, status: :created
    else
      Rails.logger.error "Build failed to save: #{@build.errors.full_messages.join(', ')}"
      render json: { errors: @build.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def ai_generated_build
    user_params = ai_build_params

    prompt = <<~PROMPT
      Suggest a PC build under $#{user_params[:budget]} for #{user_params[:use_case]}.
      Prefer #{user_params[:brand]} components and a #{user_params[:style]} style.
      Respond in valid JSON format with this exact structure:

      {
        "cpu": { "name": "", "reason": "", "price": "" },
        "gpu": { "name": "", "reason": "", "price": "" },
        "ram": { "name": "", "reason": "", "price": "" },
        "storage": { "name": "", "reason": "", "price": "" },
        "motherboard": { "name": "", "reason": "", "price": "" },
        "total_price": ""
      }

      Only respond with the JSON object, no additional text or explanation.
    PROMPT

    response = HTTParty.post(
      KLUSTER_API_ENDPOINT,
      headers: {
        "Authorization" => "Bearer #{ENV['KLUSTER_API_KEY']}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "klusterai/Meta-Llama-3.1-8B-Instruct-Turbo",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.6,
        max_tokens: 1000,
        response_format: { type: "json_object" }
      }.to_json
    )

    Rails.logger.info("Kluster AI raw response: #{response.body}")

    unless response.success?
      error_message = begin
        JSON.parse(response.body)["error"]["message"]
      rescue
        response.body
      end
      raise "Kluster AI API Error (#{response.code}): #{error_message}"
    end

    content = if response.parsed_response["choices"]
                response.parsed_response.dig("choices", 0, "message", "content")
              else
                response.parsed_response["text"] || response.parsed_response["output"]
              end

    raise "Empty response from Kluster AI" if content.blank?

    begin
      build_json = JSON.parse(content)
    rescue JSON::ParserError
      if content.match(/```json\n(.*?)\n```/m)
        build_json = JSON.parse($1)
      else
        raise
      end
    end

    required_keys = ['cpu', 'gpu', 'ram', 'storage', 'motherboard', 'total_price']
    missing_keys = required_keys - build_json.keys
    raise "Missing keys in response: #{missing_keys.join(', ')}" if missing_keys.any?

    render json: { build: build_json }

  rescue => e
    Rails.logger.error "Kluster AI Error: #{e.message}\n#{e.backtrace.join("\n")}"
    render json: {
      error: "Build generation failed",
      details: e.message,
      suggestion: "Please try again with different parameters"
    }, status: :unprocessable_entity
  end

  def build_params
    params.require(:build).permit(:cpu, :gpu, :ram, :storage, :motherboard)
  end

  def ai_build_params
    params.require(:build).permit(:budget, :use_case, :brand, :style)
  end
end
