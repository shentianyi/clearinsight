class PdcaItem < Task
  validates :title, length: { maximum: 255, too_long: '需改进项长度最大为255' }
  validates :content, length: { maximum: 255, too_long: '需改进点长度最大为255' }
  validates :result, length: { maximum: 255, too_long: '结果长度最大为255' }
  validates :remark, length: { maximum: 255, too_long: '备注长度最大为255' }


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
