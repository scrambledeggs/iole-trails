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
  validate :time_overlaps, if: -> { start.present? && duration.present? }

  def expected_end
    start + duration.hours
  end

  def time_overlaps
    trail = Trail.find(trail_id)
    return unless trail.overlaps_races?(start.to_datetime, duration.to_i)

    errors.add(:time_period, 'overlaps another race')
  end
end
