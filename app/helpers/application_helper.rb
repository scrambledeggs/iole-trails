module ApplicationHelper
  def status_tag(status)
    status_color = case status
                   when 'ONGOING', 'STARTED'
                     'ongoing'
                   when 'REGISTERED', 'NEW'
                     'new'
                   when 'FINISHED'
                     'finished'
                   when 'UNFINISHED', 'DROPPED'
                     'unfinished'
                   end
    "<mark class=#{status_color}>#{status}</mark>".html_safe
  end
end
