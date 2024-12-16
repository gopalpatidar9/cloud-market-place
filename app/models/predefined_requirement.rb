class PredefinedRequirement < ApplicationRecord
  has_many :comparisons
  has_many :cloud_platforms, through: :comparisons
end
