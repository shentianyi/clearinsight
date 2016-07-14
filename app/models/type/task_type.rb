class TaskType
  PLAN=100

  @@type_name = {
      PLAN => 'plan'
  }

  def self.get_type(type)
    self.const_get(type.upcase)
  end

  def self.get_type_name(type)
    @@type_name[type]
  end

  def self.display(type)
    case type
      when PLAN
        'plan'
    end
  end
end