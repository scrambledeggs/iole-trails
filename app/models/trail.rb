class Trail < ApplicationRecord
  has_many :practices
  has_many :people, through: :practices

  validates :name, presence: true
end
