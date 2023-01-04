module RacesHelper
  def participant_string(run)
    participant_line = "#{run.person.name.capitalize}"
    participant_line += " (#{number_with_precision(run.duration, precision: 2)}h)" if run.duration 

    "<li> #{participant_line}</li>".html_safe
  end
end
