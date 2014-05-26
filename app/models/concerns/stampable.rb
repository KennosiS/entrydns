module Stampable
  extend ActiveSupport::Concern
  
  included do
    belongs_to :creator, :class_name => 'User'
    belongs_to :updator, :class_name => 'User'
                                 
    before_create :set_creator_attribute
    before_save   :set_updator_attribute
  end
  
  def set_creator_attribute
    self.creator = User.current
  end

  def set_updator_attribute
    self.updator = User.current
  end
end