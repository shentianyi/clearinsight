module ClearInsight
  module Acts
    module Settingable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_settingable(options = {})
          return if self.included_modules.include?(ClearInsight::Acts::Settingable::InstanceMethods)
          cattr_accessor :settingable_options
          self.settingable_options = options

          embeds_many :setting_items, class_name: 'Kpi::SettingItem'

          send :include, ClearInsight::Acts::Settingable::InstanceMethods
          # validate :validate_custom_field_values
          # after_save :save_custom_field_values
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
          base.send :alias_method_chain, :reload, :custom_fields
        end

        def method_missing(method_name, *args, &block)
          if /value_\w+/.match(method_name.to_s)
            value= setting_item_values.detect { |v| v.field_name.downcase== method_name.to_s.sub(/value_/, '') }.try(:value)

          else
            super
          end
        end

        def available_setting_items
          @available_setting_items ||= setting_items.sorted.to_a
        end


        def setting_item_values
          @setting_item_values ||= available_setting_items.collect do |item|
            x = Kpi::SettingItem.new
            setting = setting_items.detect { |i| i == item }
            x.value = setting.value
            x.id=setting.id
            x.value_was = x.value.dup if x.value
            x
          end
        end


        module ClassMethods
        end
      end
    end
  end
end
