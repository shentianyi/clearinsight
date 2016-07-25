class TaskType
  PLAN=100
  PDCA_ITEM=200

  @@type_name = {
      PLAN => 'plan',
      PDCA_ITEM => 'pdca_item'
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
      when PDCA_ITEM
        'pdca_item'
    end
  end
end