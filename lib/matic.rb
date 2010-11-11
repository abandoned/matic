require "active_model"

module Matic
  extend ActiveSupport::Concern
  include ActiveModel::Dirty

  module ClassMethods
    def collection_name
      self.name.tableize
    end

    def field(attr_name)
      # Plagiarized from ActiveModel
      attribute_method_matchers.each do |matcher|
        unless instance_method_already_implemented?(matcher.method_name(attr_name))
          generate_method = "define_method_#{matcher.prefix}attribute#{matcher.suffix}"

          if respond_to?(generate_method)
            send(generate_method, attr_name)
          else
            method_name = matcher.method_name(attr_name)

            generated_attribute_methods.module_eval <<-STR, __FILE__, __LINE__ + 1
              if method_defined?(:#{method_name})
                undef :#{method_name}
              end
              def #{method_name}(*args)
                send(:#{matcher.method_missing_target}, '#{attr_name}', *args)
              end
            STR
          end
        end
      end

      define_method(attr_name) do
        self[attr_name.to_s]
      end

      define_method("#{attr_name}=") do |val|
        eval("#{attr_name}_will_change!") unless val == self[attr_name.to_s]
        self[attr_name.to_s] = val
      end
    end
  end

  def insert(opts={})
    if super
      @previously_changed = changes
      @changed_attributes.clear
    end
  end

  def insert!(opts={})
    insert(opts.merge(:safe => true))
  end

  def update(opts={}, update_doc=@doc)
    if super
      @previously_changed = changes
      @changed_attributes.clear
    end
  end

  def update!(opts={}, update_doc=@doc)
    update(opts.merge(:safe => true), update_doc)
  end

  def save
    is_new ? insert : update
  end
end
