This package helps you check that the filters and layouts in a controller have been defined correctly.

Matchers
--------
You may have created a controller as follows:

    class MyController < ApplicationController
      before_action :set_user
      before_filter :require_user, only: [:home]
      skip_before_filter :authorize

      layout 'my_layout'

      def home
        ...
      end
    end

You can spec this controller using the matchers in this package as follows:

    require 'spec_helper'

    describe MyController do
      it { should have_before_action :set_user }
      it { should have_before_filter :require_user, only: [:home] }
      it { should have_skip_before_filter(:authorize)) }
      it { should have_layout 'my_layout' }
      ...
    end

To make this matcher available in your controller specs, do the following:

Using
-----
**Gemfile**

    group :test do
      ...
      gem 'specstar-controllers', '~> 0.2.0'
      ...
    end

**spec/spec_helper.rb**

    require 'specstar/controllers'

    RSpec.configure do |config|
      ...
      config.include Specstar::Controllers::Matchers, :type => :controller
      ...
    end

Related Tools
-------------
You may also want to consider the following gems to help with your specs:

* **specstar-models**: A Ruby gem containing matchers for checking that the attributes, validations and associations of a model have been defined correctly. Learn more [here](https://github.com/sujoyg/specstar-models 'Github'). Released gems are [here](http://rubygems.org/gems/specstar-models).
* **specstar-support-random**: Utility methods for generating random objects (e.g. URLs, emails, hashes) for use in your specs. Learn more [here](https://github.com/sujoyg/specstar-support-random 'Github'). Release gems are [here](http://rubygems.org/gems/specstar-support-random). 




