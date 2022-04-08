# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr = nil, option = nil, param = nil)
      @validates ||= []
      return @validates if attr.nil? || option.nil?

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
      self.class.validate.each do |validate|
        attr = send validate[0]
        option = validate[1]
        param = validate[2]

        case option
        when :presence
          raise "Attribute is nil! Attr: #{validate[0]}" if attr.nil?
        when :format
          raise "Attribute have invalid format! Attr: #{validate[0]}" unless attr =~ param
        when :type
          raise "Attribute have invalid type! Attr: #{validate[0]}" unless attr.is_a? param
        when :comparison_min
          raise "Value (#{attr}) less then #{param}. Attr: #{validate[0]}" if attr < param
        when :comparison_min_length
          raise "Value (#{attr}) less then #{param}. Attr: #{validate[0]}" if attr.length < param
        else
          raise "Unknown validation option! (#{option})"
        end
      end
    end
  end
end
