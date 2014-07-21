module DeviseHelper
  def devise_error_messages!(field)
    return nil if resource.errors.empty?
    if resource.errors.get(field).kind_of?(Array)
      messages = resource.errors.get(field) { |msg| content_tag(:li, msg) }.join
    else
      messages = resource.errors.get(field) { |msg| content_tag(:li, msg) }
    end
    if resource.errors.get(field) !=nil
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