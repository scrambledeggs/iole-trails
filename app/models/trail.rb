class Trail < ApplicationRecord
  # before_validation :set_defaults
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
    Person.where(age: [age_minimum..age_maximum], weight: [weight_minimum..weight_maximum], body_build: body_build)
  end

  def has_ongoing_practices?
    !practices.where(status: :STARTED).empty?
  end

  def ongoing_practices
    practices.where(status: :STARTED)
  end

  def has_past_practices?
    !practices.where(status: :FINISHED).empty?
  end

  def past_practices
    finished_practices = practices.where(status: :FINISHED)
    finished_practices.uniq { |item| [item.person_id] }
  end

  private

  def age_eligible(input_age)
    lower_pass = if age_minimum.present?
                   input_age >= age_minimum
                 else
                   true
                 end
    upper_pass = if age_maximum.present?
                   input_age <= age_maximum
                 else
                   true
                 end
    lower_pass && upper_pass
  end

  def weight_eligible(input_weight)
    lower_pass = if weight_minimum.present?
                   input_weight >= weight_minimum
                 else
                   true
                 end
    upper_pass = if weight_maximum.present?
                   input_weight <= weight_maximum
                 else
                   true
                 end
    lower_pass && upper_pass
  end

  def body_build_eligible(input_body_build)
    !body_build.present? || input_body_build == body_build
  end

  def set_defaults
    puts 'set_default'
  end
end
