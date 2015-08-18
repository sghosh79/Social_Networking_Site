module ApplicationHelper
  def active_class(path)
    path == request.path ? "active" : ""       
  end
  
  def time_format(time)
    time.strftime("%B %e at %l:%M%P") rescue ""
  end
end
