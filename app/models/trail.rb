class Trail < ApplicationRecord
  enum body_build: Person.body_builds

  has_many :practices, dependent: :destroy
  has_many :people, through: :practices
  has_many :races, dependent: :destroy

  validates :name, presence: true

  def eligible?(age, weight, person_body_build)
    age_eligible(age) && weight_eligible(weight) && body_build_eligible(person_body_build)
  end

  def eligible_people
    person_body_build = body_build || Person.body_builds.keys
    self.age_minimum ||= 1
    self.age_maximum ||= 100
    date_maximum = Date.new(Date.today.year - age_minimum, 12, 31)
    date_minimum = Date.new(Date.today.year - age_maximum, 1, 1)
    Person.where(birthdate: [date_minimum..date_maximum], weight: [weight_minimum..weight_maximum], body_build: person_body_build)
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

  def upcoming_races
    races.where(status: :NEW).order(:start)
  end

  def ongoing_race
    races.where(status: :STARTED).first
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
    body_build.blank? || person_body_build == body_build
  end
end
