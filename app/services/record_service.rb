class RecordService
  def self.parse_action log
    info = []

    info<<'action'
    case log.recordable_type
      when 'Task'
        if log.recordable.type==TaskType::PLAN
          info<<TaskType.display(TaskType::PLAN)
        elsif log.recordable.type==TaskType::PDCA_ITEM
          info<<TaskType.display(TaskType::PDCA_ITEM)
        end
      else
        info<<log.recordable_type
    end

    info<<log.action
    puts info.join('.')
    info.join('.')
  end


  def self.parse_title log
    case log.recordable_type
      when 'Task'
        log.recordable.title
      when 'Project'
        log.recordable.name
      else
        log.recordable_type
    end
  end

  def self.parse_model log
    case log.recordable_type
      when 'Task'
        if log.recordable.type==TaskType::PLAN
          TaskType.display(TaskType::PLAN)
        elsif log.recordable.type==TaskType::PDCA_ITEM
          TaskType.display(TaskType::PDCA_ITEM)
        end
      else
        log.recordable_type
    end
  end
end