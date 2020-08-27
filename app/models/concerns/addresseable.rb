# frozen_string_literal: true

module Addresseable
  extend ActiveSupport::Concern

  def type_for_attribute(attr_name, &block)
    attr_name = attr_name.to_s
    if block
      self.class.attribute_types.fetch(attr_name, &block)
    else
      self.class.attribute_types[attr_name]
    end
  end
  alias column_for_attribute type_for_attribute

  def attribute?(attr_name)
    self.class.attribute_types.include? attr_name.to_s
  end

  class_methods do
    def type_for_attribute(attr_name, &block)
      attr_name = attr_name.to_s
      if block
        attribute_types.fetch(attr_name, &block)
      else
        attribute_types[attr_name]
      end
    end
    alias_method :column_for_attribute, :type_for_attribute

    def attribute?(attr_name)
      attribute_types.include? attr_name.to_s
    end
  end
end
