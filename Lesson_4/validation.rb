# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr, option, param = nil)
      case option
      when :presence
        raise "Attribute is nil! #{attr}" if attr.nil?
      when :format
        raise 'Attribute have invalid format!' unless attr =~ param
      when :type
        raise 'Attribute have invalid type!' unless attr.is_a? param
      when :comparison_min
        raise "#{attr} less then #{param}" if attr < param
      when :comparison_equal
        raise "#{attr} eqal #{param}" if attr == param
      when :not_include
        raise "#{param} didn't include #{attr}" unless param.include?(attr)
      when :include
        raise "#{param} include #{attr}" if param.include?(attr)
      else
        raise 'Unknown validation option!'
      end
    end
  end

  module InstanceMethods
    def valid?(attr, option, param = nil)
      validate!(attr, option, param)
      true
    rescue RuntimeError
      false
    end

    protected

    def validate!(attr, option, param = nil)
      self.class.validate(attr, option, param)
    end
  end
end
