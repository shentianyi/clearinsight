class PdcaItem < Task
  belongs_to :user

  default_scope { where(type: TaskType::PDCA_ITEM) }



  def owners_info
    json=[]
    self.accessers.each do |user|
      json<<{name: user.name, email: user.email}
    end

    json
  end
end
