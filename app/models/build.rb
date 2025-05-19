class Build < ApplicationRecord
  # app/models/build.rb
  belongs_to :user, optional: true

  validates :cpu, presence: true
validates :gpu, presence: true
validates :ram, presence: true
validates :storage, presence: true
validates :motherboard, presence: true
end
