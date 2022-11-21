class Trail < ApplicationRecord
  enum body_build: Person.body_builds

  has_many :practices, dependent: :destroy
  has_many :people, through: :practices

  validates :name, presence: true

  def eligible?(input_age, input_weight, input_body_build)
    age_eligible(input_age) && weight_eligible(input_weight) && body_build_eligible(input_body_build)
  end

  def eligible_people
    Person.where(age: [age_minimum..age_maximum], weight: [weight_minimum..weight_maximum], body_build: body_build)
  end

  def ongoing_practices?
    ongoing_practices.present?
  end

  def ongoing_practices
    practices.where(status: :STARTED)
  end

  def past_practices?
    past_practices.present?
  end

  def past_practices
    finished_practices = practices.where(status: :FINISHED)
    finished_practices.uniq { |item| [item.person_id] }
  end

  private

  def age_eligible(age)
    lower_pass = !(age_minimum && age < age_minimum)
    upper_pass = !(age_maximum && age > age_maximum)
    lower_pass && upper_pass
  end

  def weight_eligible(weight)
    lower_pass = !(weight_minimum && weight < weight_minimum)
    upper_pass = !(weight_maximum && weight > weight_maximum)
    lower_pass && upper_pass
  end

  def body_build_eligible(person_body_build)
    !body_build.present? || person_body_build == body_build
  end
end
