class Practice < ApplicationRecord
  enum status: {
    started: 0,
    finished: 1
  }, _prefix: true

  belongs_to :person
  belongs_to :trail
end
