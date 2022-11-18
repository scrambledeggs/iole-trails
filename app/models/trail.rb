class Trail < ApplicationRecord
  enum body_build: {
    SLIM: 0,
    FIT: 1,
    LARGE: 2
  }, _prefix: true

  has_many :practices
  has_many :people, through: :practices

  validates :name, presence: true

  def eligible?(input_age, input_weight, input_body_build)
    age_eligible(input_age) && weight_eligible(input_weight) && body_build_eligible(input_body_build)
  end

  def eligible_people
    # get all people with matching specs
  end

  private
  def age_eligible(input_age)
    lower_pass = if self[:age_minimum].present?
                   input_age >= self[:age_minimum]
                 else
                   true
                 end
    upper_pass = if self[:age_maximum].present?
                   input_age <= self[:age_maximum]
                 else
                   true
                 end
    lower_pass && upper_pass
  end

  def weight_eligible(input_weight)
    lower_pass = if self[:weight_minimum].present?
                   input_weight >= self[:weight_minimum]
                 else
                   true
                 end
    upper_pass = if self[:weight_maximum].present?
                   input_weight <= self[:weight_maximum]
                 else
                   true
                 end
    lower_pass && upper_pass
  end

  def body_build_eligible(input_body_build)
    input_body_build == self[:body_build]
  end
end
