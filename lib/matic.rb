require "active_model"

module Matic
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  module ClassMethods
    def collection_name
      self.name.tableize
    end

    def fields(*attrs)
      if attrs.first.is_a? Hash
        attrs.first.each { |k, v| define_accessor(k, v) }
        define_attribute_methods(attrs.first.keys)
      else
        attrs.each { |k, v| define_accessor(k, v) }
        define_attribute_methods(attrs)
      end
    end

    private

    def define_accessor(attr_name, attr_field=nil)
      attr_field ||= attr_name

      define_method(attr_name) do
        self[attr_field.to_s]
      end

      define_method("#{attr_name}=") do |val|
        unless val == self[attr_field.to_s]
          eval("#{attr_name}_will_change!")
        end

        self[attr_field.to_s] = val
      end
    end
  end

  def insert(opts={})
    clear_changes if super
  end

  def update(opts={}, update_doc=@doc)
    clear_changes if super
  end

  def save
    is_new ? insert : update
  end

  private

  def clear_changes
    @previously_changed = changes
    @changed_attributes.clear
  end
end
