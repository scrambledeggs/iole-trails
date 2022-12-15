class Practice < ApplicationRecord
  enum status: {
    STARTED: 0,
    FINISHED: 1
  }, _prefix: true

  belongs_to :person
  belongs_to :trail

  validate :person_eligibility, on: :create
  validate :person_availability, on: :create

  private

  def person_eligibility
    @trail = Trail.find(trail_id)
    @person = Person.find(person_id)

    return if @person.practice_on?(@trail)

    errors.add(:person_id, 'not eligible for this trail')
  end

  def person_availability
    @person = Person.find(person_id)

    return if !@person.ongoing_race?

    errors.add(:person_id, 'already has an ongoing race')
  end
end
