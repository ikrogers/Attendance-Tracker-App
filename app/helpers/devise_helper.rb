module DeviseHelper
  def devise_error_messages!(field)
    return nil if resource.errors.empty?
    messages = resource.errors.full_messages_for(field).map { |msg| content_tag(:li, msg) }.join
    if resource.errors.full_messages_for(field) != []
      html = <<-HTML
    <div class="alert alert-error alert-block"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
    else
      return nil
    end
  end

end