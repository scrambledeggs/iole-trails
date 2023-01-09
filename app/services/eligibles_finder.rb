class EligiblesFinder < ApplicationService
  def initialize(trail)
    @trail = trail
  end

  def call
    @trail.age_minimum ||= 1
    @trail.age_maximum ||= 100
    date_maximum = Date.today - @trail.age_minimum.years
    date_minimum = Date.today - @trail.age_maximum.years - 1.year

    Person.where(
      birthdate: [date_minimum..date_maximum],
      weight: [@trail.weight_minimum..@trail.weight_maximum],
      body_build: @trail.body_build || Person.body_builds.keys
    )
  end
end
