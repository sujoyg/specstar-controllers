require 'rspec/core'

module Specstar
  module Controllers
    module Matchers
      RSpec::Matchers.define :have_layout do |expected|
        match do |controller|
          if expected
            expected.to_s == controller.class.instance_variable_get("@_layout")
          else
            controller.class.instance_variable_get("@_layout")
          end
        end

        failure_message do |controller|
          if expected
            "Expected #{controller.class.name} to have layout '#{expected}'."
          else
            "Expected #{controller.class.name} to have layout."
          end
        end

        failure_message_when_negated do |controller|
          if expected
            "Expected #{controller.class.name} not to have layout '#{expected}'."
          else
            "Expected #{controller.class.name} not to have layout."
          end
        end
      end

      def has_skip_before_filter_for_action?(controller, filter, action)
        controller._process_action_callbacks.any? { |callback|
          callback.kind == :before && callback.filter.to_s == filter.to_s && callback.per_key[:unless].any? { |item| item.include? "action_name == '#{action}'" }
        }
      end

      def has_skip_before_filter?(controller, filter, actions=[])
        if actions.present?
          actions.all? { |action| has_skip_before_filter_for_action?(controller, filter, action) }
        else
          !has_before_filter?(controller, filter)
        end
      end

      def callback_matches?(callback, condition, actions)
        field = "@#{condition}"

        if actions.size > 0
          actions.all? { |a|
            callback.instance_variable_get(field).any? { |item| item.include? "action_name == '#{a}'" }
          }
        else
          callback.instance_variable_get(field).empty?
        end
      end

      def has_before_filter?(controller, filter, options={})
        result = true

        if options.include?(:only)
          result = controller._process_action_callbacks.any? { |callback|
            callback.kind == :before && callback.filter.to_s == filter.to_s && callback_matches?(callback, :if, options[:only])
          }
        end

        if result && options.include?(:except)
          result = controller._process_action_callbacks.any? { |callback|
            callback.kind == :before && callback.filter.to_s == filter.to_s && callback_matches?(callback, :unless, options[:except])
          }
        end

        if result && options.blank?
          result = controller._process_action_callbacks.any? { |callback|
            callback.kind == :before && callback.filter.to_s == filter.to_s
          }
        end

        result
      end

      def has_before_action?(controller, action, options={})
      	  has_before_filter? controller, action, options
      end

      RSpec::Matchers.define :have_skip_before_filter do |filter|
        chain :only do |actions|
          @actions = *actions
        end

        match do |controller|
          has_skip_before_filter?(controller, filter, @actions)
        end

        failure_message do |controller|
          "Expected #{controller.class.name} to have a skip before filter '#{filter}'."
        end

        failure_message_when_negated do |controller|
          "Expected #{controller.class.name} not to have a skip before filter '#{filter}'."
        end

        description do
          "have a skip before filter '#{filter}'."
        end
      end


      RSpec::Matchers.define :have_before_action do |action, options={}|
        match do |controller|
          has_before_action?(controller, action, options)
        end

        failure_message do |controller|
          if options
            "Expected #{controller.class.name} to have a before_action #{action} with #{options}."
          else
            "Expected #{controller.class.name} to have a before_action #{action}."
          end
        end

        failure_message_when_negated do |controller|
          if options
            "Expected #{controller.class.name} not to have a before_action #{action} with #{options}."
          else
            "Expected #{controller.class.name} not to have a before_action #{action}."
          end
        end

        description do
          "have a before action '#{action}'."
        end
      end


      RSpec::Matchers.define :have_before_filter do |filter, options={}|
        match do |controller|
          has_before_filter?(controller, filter, options)
        end

        failure_message do |controller|
          if options
            "Expected #{controller.class.name} to have a before_filter #{filter} with #{options}."
          else
            "Expected #{controller.class.name} to have a before_filter #{filter}."
          end
        end

        failure_message_when_negated do |controller|
          if options
            "Expected #{controller.class.name} not to have a before_filter #{filter} with #{options}."
          else
            "Expected #{controller.class.name} not to have a before_filter #{filter}."
          end
        end

        description do
          "have a before filter '#{filter}'."
        end
      end
    end
  end
end
