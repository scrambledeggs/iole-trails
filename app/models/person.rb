class Person < ApplicationRecord
  enum body_build: {
    SLIM: 0,
    FIT: 1,
    LARGE: 2
  }, _prefix: true

  has_many :practices
  has_many :trails, through: :practices

  validates :name, presence: true
  validates :age, presence: true
  validates :weight, presence: true
  validates :body_build, presence: true

  def has_ongoing_trail?
    !practices.empty?
  end
end
