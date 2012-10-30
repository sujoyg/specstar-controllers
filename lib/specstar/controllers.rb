require 'rspec'

module Specstar
  module Controllers
    module Matchers
      RSpec::Matchers.define :have_layout do |expected|
        match do |controller|
          expected.to_s == controller.class.instance_variable_get("@_layout")
        end

    	failure_message_for_should do |controller|
      	  "Expected #{controller.class.name} to have layout '#{expected}'."
    	end

    	failure_message_for_should_not do |controller|
      	  "Expected #{controller.class.name} not to have layout '#{expected}'."
    	end
      end

      def has_skip_before_filter?(controller, filter, actions)
        if actions.present?
          controller._process_action_callbacks.select { |callback|
            callback.chain.select { |chain|
	      actions_match = actions.select { |action| !chain.per_key[:unless].include?("action_name == '#{action}'") }.empty?
              chain.kind == :before && chain.filter.to_s == filter.to_s && actions_match
            }.size > 0
          }.size > 0
	else
	  !has_before_filter?(controller, filter)
	end
      end

      def has_before_filter?(controller, filter, action=nil)
        callbacks = controller.is_a?(ApplicationController) ? controller._process_action_callbacks : controller._dispatch_callbacks
        callbacks.select { |callback|
          callback.chain.select { |chain|
            chain.kind == :before && chain.filter.to_s == filter.to_s && (action.nil? || chain.per_key[:if].include?("action_name == '#{action}'"))
          }.size > 0
        }.size > 0
      end

      RSpec::Matchers.define :have_skip_before_filter do |filter|
        chain :only do |actions|
          @action = *actions
        end

        match do |controller|
          has_skip_before_filter?(controller, filter, @action)
        end

    	failure_message_for_should do |controller|
      	  "Expected #{controller.class.name} to have a skip before filter '#{filter}'."
    	end

    	failure_message_for_should_not do |controller|
      	  "Expected #{controller.class.name} not to have a skip before filter '#{filter}'."
    	end

    	description do
      	  "have a skip before filter '#{filter}'."
    	end
      end

      RSpec::Matchers.define :have_before_filter do |filter|
        chain :only do |action|
          @action = action
        end

        match do |controller|
          has_before_filter?(controller, filter, @action)
        end

    	failure_message_for_should do |controller|
      	  "Expected #{controller.class.name} to have a before filter '#{filter}'."
    	end

    	failure_message_for_should_not do |controller|
      	  "Expected #{controller.class.name} not to have a before filter '#{filter}'."
    	end

    	description do
      	  "have a before filter '#{filter}'."
    	end
      end
    end
  end
end