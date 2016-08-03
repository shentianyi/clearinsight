require 'active_support/concern'

module Extensions
  module LOGABLE
    extend ActiveSupport::Concern
    included do
      after_create :set_create_record

      def set_create_record
        puts self
        puts self.class

        case self.class
          when 'Project'
            record=Record.new(action: 'create')
            record.logable = self
            record.recordable = self

        end




        record.save
      end

    end
  end
end