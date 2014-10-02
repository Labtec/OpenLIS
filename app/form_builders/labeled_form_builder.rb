class LabeledFormBuilder < ActionView::Helpers::FormBuilder

  helpers = %w{text_field password_field select date_select datetime_select text_area collection_select email_field telephone_field number_field date_ios_select datetime_ios_select }
  
  helpers.each do |method_name|
    define_method(method_name) do |field_name, *args|
      @template.content_tag(:div, field_label(field_name, *args) + super, :class => field_name)
    end
  end
  
  def check_box(field_name, *args)
    @template.content_tag(:div, super + " " + field_label(field_name, *args), :class => field_name)
  end
  
  def many_check_boxes(name, subobjects, id_method, name_method, options = {})
    field_name = "#{object_name}[#{name}][]"
    subobjects.map do |subobject|
      @template.content_tag(:div, :class => subobject.class.to_s.underscore) do
        @template.check_box_tag(field_name, subobject.send(id_method), object.send(name).include?(subobject.send(id_method)), :id => @template.dom_id(subobject)) + @template.label_tag(@template.dom_id(subobject), subobject.send(name_method), :class => "checkbox", :onclick => "")
      end
    end.to_s + @template.hidden_field_tag(field_name, "")
  end

private
  
  def field_label(field_name, *args)
    options = args.extract_options!
    options[:label_class] = "required" if options[:required]
    label(field_name, options[:label], :class => options[:label_class])
  end

  # def objectify_options(options)
  #   super.except(:label, :required, :label_class)
  # end
end
