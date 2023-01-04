module TrailsHelper
  def age_criteria_line(trail)
    line = case [trail.age_minimum.present?, trail.age_maximum.present?]
             when [false, false]
               'Any'
             when [false, true]
               "Up to #{trail.age_maximum}"
             when [true, false]
               "At least #{trail.age_minimum}"
             when [true, true]
               "#{trail.age_minimum} to #{trail.age_maximum}"
           end
    line.html_safe
  end

  def weight_criteria_line(trail)
    line = case [trail.weight_minimum.present?, trail.weight_maximum.present?]
             when [false, false]
               'Any'
             when [false, true]
               "Up to #{trail.weight_maximum}"
             when [true, false]
               "At least #{trail.weight_minimum}"
             when [true, true]
               "#{trail.weight_minimum} to #{trail.weight_maximum}"
           end
    line.html_safe
  end

  def body_build_criteria_line(trail)
    line = trail.body_build || 'Any'
    line.html_safe
  end
end
