class BuildComponent < ApplicationRecord
  belongs_to :build
  belongs_to :component
end
