# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :validates

    def validate(attr, option, param = nil)
      @validates ||= []
      @validates << [attr, option, param]
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    protected

    def validate!
      self.class.validates.each do |attr, option, param|
        send option, send(attr), param
      end
    end

    def presence(attr, _param)
      raise "Attribute is nil! Attr: #{attr}" if attr.nil?
    end

    def format(attr, param)
      raise "Attribute have invalid format! Attr: #{attr}" unless attr =~ param
    end

    def type(attr, param)
      raise "Attribute have invalid type! Attr: #{attr}" unless attr.is_a? param
    end

    def comparison_min(attr, param)
      raise "Value (#{attr}) less then #{param}!" if attr < param
    end

    def comparison_min_length
      raise "Value (#{attr}) less then #{param}!" if attr.length < param
    end
  end
end
