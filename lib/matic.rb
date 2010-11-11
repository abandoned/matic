require "active_model"

module Matic
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  module ClassMethods
    def collection_name
      self.name.tableize
    end

    def field(attr_name)
      generate_attribute_methods(attr_name)

      define_method(attr_name) do
        self[attr_name.to_s]
      end

      define_method("#{attr_name}=") do |val|
        unless val == self[attr_name.to_s]
          eval("#{attr_name}_will_change!")
        end

        self[attr_name.to_s] = val
      end
    end

    private

    def generate_attribute_methods(attr_name)
      attribute_method_matchers.each do |matcher|
        method_name = matcher.method_name(attr_name)

        generated_attribute_methods.module_eval <<-STR, __FILE__, __LINE__ + 1
          def #{method_name}(*args)
            send(:#{matcher.method_missing_target}, '#{attr_name}', *args)
          end
        STR
      end
    end
  end

  def insert(opts={})
    clear_changes if super
  end

  def insert!(opts={})
    insert(opts.merge(:safe => true))
  end

  def update(opts={}, update_doc=@doc)
    clear_changes if super
  end

  def update!(opts={}, update_doc=@doc)
    update(opts.merge(:safe => true), update_doc)
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
