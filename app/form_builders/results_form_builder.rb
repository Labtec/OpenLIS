##
# Not working
# Keep searching info on form builders
class ResultsFormBuilder < ActionView::Helpers::FormBuilder
  def value_input_field(value_method)
    if object.lab_test.derivation
      "(calc.)"
    elsif object.lab_test.lab_test_values.blank?
      field_name = "#{object_name}[value]"
      @template.text_field_tag(field_name, value = object.send(value_method), :size => 13)
    else
      @template.collection_select(object_name, :value, LabTest.find(object.lab_test_id).lab_test_values, :id, :value, { :include_blank => true })
#      "#{object.send(value_method)}"
    end
  end
  
  #<%= f.check_box :range %>
  def check_box(field_name, *args)
    @template.content_tag(:p, super + " " + field_label(field_name, *args))
  end

  #<%= f.many_check_boxes :panel_ids, Panel.all, :id, :name %>
  def many_check_boxes(name, subobjects, id_method, name_method, options = {})
    field_name = "#{object_name}[#{name}][]"
    subobjects.map do |subobject|
      @template.content_tag(:div, :class => subobject.class.to_s.underscore) do
        @template.check_box_tag(field_name, subobject.send(id_method), object.send(name).include?(subobject.send(id_method))) + " " + subobject.send(name_method)
      end
    end.to_s + @template.hidden_field_tag(field_name, "")
  end

  def submit(*args)
    @template.content_tag(:p, super, :class => "submit")
  end
end
