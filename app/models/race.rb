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

  before_commit :finish_sequence, on: :update

  def expected_end
    start + duration.hours
  end

  def registered_runs
    runs.where(status: %i[REGISTERED FINISHED UNFINISHED])
  end

  private

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

  def finish_sequence
    return unless status_FINISHED?

    formatted_updates = []
    first_placer = 0
    rand_duration = registered_runs.length.times.map { rand((duration / 2)..(duration + 1.5)) }
    sorted_duration = rand_duration.sort

    registered_runs.each_with_index do |run, index|
      run_duration = rand_duration[index]
      run_status = if run_duration <= duration
                     :FINISHED
                   else
                     :UNFINISHED
                   end
      run_place = sorted_duration.find_index(run_duration) + 1

      first_placer = run.id if run_place == 1

      formatted_updates << { id: run.id, duration: run_duration, status: run_status, place: run_place }
    end

    formatted_updates = formatted_updates.index_by { |run| run[:id] }

    Run.update(formatted_updates.keys, formatted_updates.values)

    update_attribute(:winner, first_placer)
  end
end
