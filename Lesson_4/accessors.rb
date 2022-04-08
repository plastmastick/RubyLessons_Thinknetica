# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |name|
        var_name = "@#{name}".to_sym
        define_method("#{name}=".to_sym) do |value|
          history = instance_variable_get(var_name)
          history ||= []
          history << value
          instance_variable_set(var_name, history)
        end

        define_method(name) do
          return nil if instance_variable_get(var_name).nil?

          instance_variable_get(var_name).last
        end

        define_method("#{name}_history".to_sym) { instance_variable_get(var_name) }
      end
    end

    def strong_attr_accessor(*args)
      args.each do |name|
        var_name = "@#{name}".to_sym
        define_method("#{name}_set".to_sym) do |value, class_type|
          strong_attr_validate!(value, class_type)
          instance_variable_set(var_name, value)
        end

        define_method(name) { instance_variable_get(var_name) }
      end
    end
  end

  module InstanceMethods
    protected

    def strong_attr_validate!(value, class_type)
      raise "Wrong class value! Expected class: (#{class_type})" unless value.is_a? class_type
    end
  end
end
