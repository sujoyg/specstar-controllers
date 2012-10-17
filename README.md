This package helps you check that the filters and layouts in a controller have been defined correctly.

You may have created a controller as follows:

    class MyController < ApplicationController
      before_filter :set_user
      skip_before_filter :authorize, :only => [:home]

      layout 'my_layout'

      def home
        ...
      end
    end

You can spec this controller using the matchers in this package as follows:

    require 'spec_helper'

    describe MyController do
      it { should have_before_filter(:set_user) }
      it { should have_skip_before_filter(:authorize).only([:home]) }
      it { should have_layout 'my_layout' }
      ...
    end

To make this matcher available in your controller specs, do the following:

**Gemfile**

    group :test do
      ...
      gem 'specstar-controllers', '~> 0.0.3'
      ...
    end

**spec/spec_helper.rb**

    require 'specstar/controllers'

    RSpec.configure do |config|
      ...
      config.include Specstar::Controllers::Matchers, :type => :controller
      ...
    end


