class Person < ApplicationRecord
  enum body_build: {
    SLIM: 0,
    FIT: 1,
    LARGE: 2
  }, _prefix: true

  has_many :practices, dependent: :destroy
  has_many :trails, through: :practices
  has_many :runs, dependent: :destroy
  has_many :races, through: :runs

  validates :name, presence: true
  validates :birthdate, presence: true
  validates :weight, presence: true
  validates :body_build, presence: true

  def age
    ((Time.zone.now - birthdate.to_time) / 1.year.seconds).floor
  end

  def ongoing_practice?
    ongoing_practice.present?
  end

  def ongoing_practice
    practices.where(status: :STARTED).first
  end

  def past_practices?
    past_practices.present?
  end

  def past_practices
    practices.where(status: :FINISHED)
  end

  def practice_on?(trail)
    !ongoing_practice? && trail.eligible?(age, weight, body_build)
  end

  def get_trail_options(trails)
    trails.collect do |t|
      validity = " (ineligible)" if !t.eligible?(age, weight, body_build)
      [ "#{t.name}#{validity}", t.id ]
    end
  end

  def ongoing_race?
    ongoing_race.present?
  end

  def ongoing_race
    races.where('"races"."status" = 1 AND "runs"."status" = 0').first
  end

  def finished_practice_on?(trail_id)
    past_practices.where(trail_id: trail_id).present?
  end

  def registered_runs
    runs.where(status: :REGISTERED)
  end
end
