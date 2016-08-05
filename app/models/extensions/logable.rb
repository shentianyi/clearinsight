require 'active_support/concern'

module Extensions
  module LOGABLE
    extend ActiveSupport::Concern
    included do
      after_create :set_create_record
      after_update :set_update_record

      def set_create_record
        puts self.class
        case self.class.to_s
          when 'PdcaItem'
            content="成功新建PDCA： #{self.title}; 操作者：#{self.user.name}"
            record=Record.new(content: content)
            record.logable = self.taskable
            record.save
          when 'Plan'
            content="成功新建Plan： #{self.title}; 操作者：#{self.user.name}"
            record=Record.new(content: content)
            record.logable = self.taskable
            record.save
          when 'ProjectItem'
            content="成功新建轮次： #{self.name}; 操作者：#{self.user.name}"
            record=Record.new(content: content)
            record.logable = self
            record.save
          else

        end
      end

      def set_update_record
        puts self.class
        record=Record.new()
        case self.class.to_s
          when 'PdcaItem'
            if self.status==TaskStatus::CANCEL
              record.content="成功取消PDCA： #{self.title}; 操作者：#{User.current_operator.name}"
            elsif self.status==TaskStatus::DONE
              record.content="成功结束PDCA： #{self.title}; 操作者：#{User.current_operator.name}"
            else
              record.content="成功更新PDCA： #{self.title}; 操作者：#{User.current_operator.name}"
            end
            record.logable = self.taskable
          when 'Plan'
            record.content="成功更新Plan： #{self.title}; 操作者：#{User.current_operator.name}"
            record.logable = self.taskable
          when 'ProjectItem'
            if self.rank==1
              record.content="标记最优： 将本轮#{self.name}标记为最优; 操作者：#{User.current_operator.name}"
              record.logable = self
            end
        end
        record.save unless record.content.blank?
      end


    end
  end
end