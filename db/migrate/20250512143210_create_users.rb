class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
  t.string :email, null: false, default: ""
  # Add other necessary columns
  t.timestamps null: false

    end
  end
end
