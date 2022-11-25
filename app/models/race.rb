class Race < ApplicationRecord
  enum status: {
    NEW: 0,
    STARTED: 1,
    FINISHED: 2
  }, _prefix: true

  belongs_to :trail

  has_many :runs, dependent: :destroy
  has_many :people, through: :runs

  validates :name, presence: true
  validates :start, presence: true
  validates :duration, presence: true
  validate :detail_change_allowed, on: :update, unless: :status_changed?
  validate :time_overlaps, if: :start_changed? || :duration_changed?
  validate :status_change, on: :update, if: :status_changed?

  def expected_end
    start + duration.hours
  end

  def registered_runs
    runs.where(status: :REGISTERED)
  end

  def detail_change_allowed
    return if registered_runs.blank?

    errors.add(:detail, 'changes no longer allowed')
  end

  def time_overlaps
    trail = Trail.find(trail_id)
    overlaps = trail.overlapping_races(start.to_datetime, duration.to_i)
    return if overlaps.blank? || (overlaps.length == 1 && overlaps.find(id))

    errors.add(:time_period, 'overlaps another race')
  end

  def status_change
    return unless status_STARTED?

    return if registered_runs.length > 1

    errors.add(:status, 'Cannot start with less than 2 participants')
  end
end
