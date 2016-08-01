class TaskStatus<BaseStatus
  ON_GOING = 100
  DONE = 200
  CANCEL = 300

  def self.display status
    case status
      when ON_GOING
        '进行中'
      when DONE
        '结束'
      when CANCEL
        '取消'
      else
        '放弃'
    end
  end
end