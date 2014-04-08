module ApplicationHelper
  def current_url(new_params)
    url_for :params => params.merge(new_params)
    #params.merge!(new_params)
    #string = params.map{ |k,v| "#{k}=#{v}" }.join("&")
    #request.original_url.split("?")[0] + "?" + string
  end

  def build_validated_field(form_name, field, name, message, pattern, type, value)
    html = ""
    html << "<div class='form-row'>"
    html << "<div class='small-3 columns'>"
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    html << "</div>"
    html << "<div class='small-9 columns'>"
    if type == 'password'
      html << password_field_tag("#{form_name}[#{field}]", value, :class => 'text_field', :required => '', :pattern => pattern, :placeholder => name)
    elsif type == 'file'
      html << file_field_tag("#{form_name}[#{field}]", :required => '', :pattern => pattern, :placeholder => name)
    elsif type == 'radio'
      html << radio_button_tag("#{form_name}[#{field}]", value, :class => 'text_field', :required => '', :pattern => pattern, :placeholder => name)
    elsif type == 'checkbox'
      html << check_box_tag("#{form_name}[#{field}]", value, :class => 'text_field', :required => '', :pattern => pattern, :placeholder => name)
    elsif type == 'text_area'
      html << text_area_tag("#{form_name}[#{field}]", value, :class => 'text_field', :required => '', :pattern => pattern, :placeholder => name,:rows=>1)
    elsif type == 'date_field'
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'text_field date-input form-control', :required => '', :pattern => pattern, :placeholder => name)
    elsif type == 'date_only_field'
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'text_field date-only-input form-control', :required => '', :pattern => pattern, :placeholder => name)
    elsif type == 'time-field'
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'text_field time-field form-control', :required => '', :pattern => pattern, :placeholder => name)
    else
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'text_field', :required => '', :pattern => pattern, :placeholder => name)
    end
    #html << "<small class='error'>#{message.blank? ? 'Cannot be blank' : message}</small>"
    html << "</div>"
    html << "</div>"
    return html.html_safe
  end

  def build_field(form_name, field, name, type, value)
    html = ""
    html << "<div class='form-row'>"
    html << "<div class='small-3 columns'>"
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    html << "</div>"
    html << "<div class='small-9 columns'>"
    if type == 'password'
      html << password_field_tag("#{form_name}[#{field}]", value, :class => 'text_field', :placeholder => name)
    elsif type == 'file'
      html << file_field_tag("#{form_name}[#{field}]", :class => 'text_field')
    elsif type == 'radio'
      html << radio_button_tag("#{form_name}[#{field}]", value, :class => 'text_field', :placeholder => name)
    elsif type == 'checkbox'
      html << check_box_tag("#{form_name}[#{field}]", value, :class => 'text_field', :placeholder => name)
    elsif type == 'text_area'
      html << text_area_tag("#{form_name}[#{field}]", value, :class => 'text_field', :placeholder => name,:rows=>1)
    else
      html << text_field_tag("#{form_name}[#{field}]", value, :class => 'text_field', :placeholder => name)
    end
    html << "</div>"
    html << "</div>"
    return html.html_safe
  end

  def build_validated_select(form_name, field, name, message, pattern, multiple, value, options)
    html = ""
    html << "<div class='form-row'>"
    html << "<div class='small-3 columns'>"
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    html << "</div>"
    html << "<div class='small-9 columns'>"
    html << select_tag("#{form_name}[#{field}]", options_for_select(options, value), {:multiple => multiple})
    #html << "<small class='error'>#{message.blank? ? 'Cannot be blank' : message}</small>"
    html << "</div>"
    html << "</div>"
    return html.html_safe
  end
  def build_select(form_name, field, name,  multiple, value, options)
    html = ""
    html << "<div class='form-row'>"
    html << "<div class='small-3 columns'>"
    html << label_tag("#{form_name}_#{field}", name, :class => 'left inline')
    html << "</div>"
    html << "<div class='small-9 columns'>"
    html << select_tag("#{form_name}[#{field}]", options_for_select(options, value), {:multiple => multiple})
    #html << "<small class='error'>#{message.blank? ? 'Cannot be blank' : message}</small>"
    html << "</div>"
    html << "</div>"
    return html.html_safe
  end
end
