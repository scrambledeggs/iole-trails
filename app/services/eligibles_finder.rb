class EligiblesFinder < ApplicationService
  def initialize(trail)
    @trail = trail
  end

  def call
    Person.where(
      age: [@trail.age_minimum..@trail.age_maximum],
      weight: [@trail.weight_minimum..@trail.weight_maximum],
      body_build: @trail.body_build || Person.body_builds.keys
    )
  end
end
