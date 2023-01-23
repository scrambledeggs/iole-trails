module RacesHelper
  def participant_line(run)
    participant_line = "#{run.person.name}"
    participant_line += " (#{run.duration}h)" if run.duration

    "<li>#{participant_line}</li>".html_safe
  end
end
