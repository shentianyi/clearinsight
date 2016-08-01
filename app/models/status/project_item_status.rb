class ProjectItemStatus<BaseStatus
  ON_GOING = 100
  FINISHED = 200

  def self.display status
    case status
      when ON_GOING
        '进行中'
      when FINISHED
        '完成'
      else
        '放弃'
    end
  end
end