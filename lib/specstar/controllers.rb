require 'rspec'

module Specstar
  module Controllers
    module Matchers
      RSpec::Matchers.define :have_layout do |expected|
        match do |controller|
          expected == controller.class.instance_variable_get("@_layout")
        end
      end

      def has_skip_before_filter?(controller, filter, action)
        controller._process_action_callbacks.select { |callback|
          callback.chain.select { |chain|
            chain.kind == :before && chain.filter == filter && (action.nil? || chain.per_key[:unless].include?("action_name == '#{action}'"))
          }.size > 0
        }.size > 0
      end

      def has_before_filter?(controller, filter, action)
        callbacks = controller.is_a?(ApplicationController) ? controller._process_action_callbacks : controller._dispatch_callbacks
        callbacks.select { |callback|
          callback.chain.select { |chain|
            chain.kind == :before && chain.filter == filter && (action.nil? || chain.per_key[:if].include?("action_name == '#{action}'"))
          }.size > 0
        }.size > 0
      end

      RSpec::Matchers.define :have_skip_before_filter do |filter|
        chain :only do |action|
          @action = action
        end

        match do |controller|
          has_skip_before_filter?(controller, filter, @action)
        end
      end

      RSpec::Matchers.define :have_before_filter do |filter|
        chain :only do |action|
          @action = action
        end

        match do |controller|
          has_before_filter?(controller, filter, @action)
        end
      end
    end
  end
end