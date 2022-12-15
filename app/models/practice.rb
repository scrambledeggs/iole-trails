class Practice < ApplicationRecord
  enum status: {
    STARTED: 0,
    FINISHED: 1
  }, _prefix: true

  belongs_to :person
  belongs_to :trail
end
