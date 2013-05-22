module ApplicationHelper
  def flash_class(name)
    if name == :notice
      'alert-success'
    else
      'alert-error'
    end
  end
end
