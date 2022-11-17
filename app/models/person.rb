class Person < ApplicationRecord
  has_many :practices
  has_many :trails, through: :practices

  validates :name, presence: true
  validates :age, presence: true
  validates :weight, presence: true
  validates :body_build, presence: true
end
