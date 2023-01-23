module RacesHelper
  def participant_line(run)
    participant_line = "#{run.person.name}"
    participant_line += " (#{number_with_precision(run.duration, precision: 2)}h)" if run.duration

    "<li>#{participant_line}</li>".html_safe
  end
end
