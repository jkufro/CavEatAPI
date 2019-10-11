module ApplicationHelper
  # https://stackoverflow.com/questions/3705898/best-way-to-add-current-class-to-nav-in-rails-3
  def nav_link(link_text, link_path)
    li_class = current_page?(link_path) ? 'active nav-item' : 'nav-item'
    content_tag(:li, :class => li_class) do
      link_to link_text, link_path, class: 'nav-link'
    end
  end

  # https://coderwall.com/p/jzofog/ruby-on-rails-flash-messages-with-bootstrap
  def flash_class(level)
    case level.to_s
    when 'notice' then "alert alert-info"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-error"
    when 'alert' then "alert alert-error"
    else
      "alert alert-info"
    end
end
end
