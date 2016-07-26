class PdcaItem < Task
  belongs_to :user

  default_scope { where(type: TaskType::PDCA_ITEM) }



end
