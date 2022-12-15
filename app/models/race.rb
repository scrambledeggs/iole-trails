class Race < ApplicationRecord
  enum status: {
    NEW: 0,
    STARTED: 1,
    FINISHED: 2
  }, _prefix: true

  belongs_to :trail

  validates :name, presence: true
  validates :start, presence: true
  validates :duration, presence: true
end
