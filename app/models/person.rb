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

  def has_ongoing_practice?
    !practices.where(status: :STARTED).empty?
  end

  def ongoing_practice
    practices.where(status: :STARTED)[0]
  end

  def has_past_practices?
    !practices.where(status: :FINISHED).empty?
  end

  def past_practices
    practices.where(status: :FINISHED)
  end
end
