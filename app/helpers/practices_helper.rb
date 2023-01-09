module PracticesHelper
  def trail_options(person)
    Trail.all.collect do |t|
      validity = " (ineligible)" if !t.eligible?(person.age, person.weight, person.body_build)
      ["#{t.name}#{validity}", t.id]
    end
  end
end
