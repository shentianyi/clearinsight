require File.dirname(__FILE__) + '/lib/acts_as_settingable'
ActiveRecord::Base.send(:include, CI::Acts::Customizable)