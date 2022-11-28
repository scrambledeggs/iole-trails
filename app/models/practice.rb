class Practice < ApplicationRecord
  enum status: {
    STARTED: 0,
    FINISHED: 1
  }, _prefix: true

  belongs_to :person
  belongs_to :trail

  validate :person_eligibility

  def person_eligibility
    @trail = Trail.find(trail_id)
    @person = Person.find(person_id)

    return if @person.practice_on?(@trail)

    errors.add(:person_id, 'not eligible for this trail')
  end
end
