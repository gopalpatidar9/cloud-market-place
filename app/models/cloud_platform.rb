class CloudPlatform < ApplicationRecord
  has_many :comparisons
  has_many :predefined_requirements, through: :comparisons
end
