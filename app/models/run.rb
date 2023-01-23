class Run < ApplicationRecord
  enum status: {
    REGISTERED: 0,
    DROPPED: 1,
    FINISHED: 2,
    UNFINISHED: 3
  }, _prefix: true

  belongs_to :person
  belongs_to :race

  validates :person_id, uniqueness: {
    scope: :race_id,
    message: 'already registered for this race'
  }
  validate :person_availability, on: :create
  validate :person_eligibility, on: :create
  validate :race_ongoing_registration, on: :create
  validate :race_overlaps_registered, on: :create

  def duration
    ActionController::Base.helpers.number_with_precision(self[:duration], precision: 2) if self[:duration].present?
  end

  private

  def person_availability
    person = Person.find(person_id)
    return if !person.ongoing_practice?

    errors.add(:person_id, 'has an ongoing practice')
  end

  def person_eligibility
    person = Person.find(person_id)
    trail_id = Race.find(race_id).trail_id

    return if person.finished_practice_on?(trail_id)

    errors.add(:person_id, 'did not finish practice for this trail')
  end

  def race_ongoing_registration
    return if Race.find(race_id).status_NEW?

    errors.add(:race_id, 'no longer accepting registrations')
  end

  def race_overlaps_registered
    registered_runs = Person.find(person_id).registered_runs
    tentative_race = Race.find(race_id)

    registered_runs.each do |run|
      next if !run.race.overlaps?(tentative_race.start, tentative_race.duration)

      errors.add(:race_id, 'overlaps with another registered race')
      break
    end
  end
end
