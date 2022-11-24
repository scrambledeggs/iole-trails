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
end
