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
    when 'notice' then "alert alert-primary"
    when 'success' then "alert alert-success"
    when 'error' then "alert alert-danger"
    when 'alert' then "alert alert-warning"
    else
      "alert alert-info"
    end
  end

  def link_if_present(url, text=nil, fallback='N/A')
    text ||= url
    return fallback unless url.present?

    link_to text, url
  end
end
