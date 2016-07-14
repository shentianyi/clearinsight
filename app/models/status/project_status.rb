class ProjectStatus<BaseStatus
  ON_GOING = 100
  GAME_VOER = 200

  def self.display status
    case status
      when ON_GOING
        '进行中'
      when GAME_VOER
        '完成'
      else
        '放弃'
    end
  end
end