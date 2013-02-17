require 'rspec/core'

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

      def has_skip_before_filter_for_action?(controller, filter, action)
        controller._process_action_callbacks.any? { |callback|
          callback.chain.any? { |chain|
            chain.kind == :before && chain.filter.to_s == filter.to_s && chain.per_key[:unless].any? { |item| item.include? "action_name == '#{action}'" }
          }
        }
      end

      def has_before_filter_for_action?(controller, filter, action=nil)
        controller._process_action_callbacks.any? { |callback|
          callback.chain.any? { |chain|
	    if action
              chain.kind == :before && chain.filter.to_s == filter.to_s && chain.per_key[:if].any? { |item| item.include? "action_name == '#{action}'" }
	    else
              chain.kind == :before && chain.filter.to_s == filter.to_s
	    end
          }
        }
      end

      def has_skip_before_filter?(controller, filter, actions=[])
        if actions.present?
	  actions.all? { |action| has_skip_before_filter_for_action?(controller, filter, action) }
	else
	  !has_before_filter?(controller, filter)
	end
      end

      def has_before_filter?(controller, filter, actions=[])
        if actions.present?
	  actions.all? { |action| has_before_filter_for_action?(controller, filter, action) }
	else
	  has_before_filter_for_action?(controller, filter)
	end
      end

      RSpec::Matchers.define :have_skip_before_filter do |filter|
        chain :only do |actions|
          @actions = *actions
        end

        match do |controller|
          has_skip_before_filter?(controller, filter, @actions)
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
        chain :only do |actions|
          @actions = *actions
        end

        match do |controller|
          has_before_filter?(controller, filter, @actions)
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
