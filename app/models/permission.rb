class Permission < ActiveRecord::Base
  stampable
  
  belongs_to :domain, :inverse_of => :permissions
  belongs_to :user, :inverse_of => :permissions
  
  validates :domain_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {
    :scope => :domain_id,
    :message => "already is permitted"
  }
  validates :user, :presence => {
    :if => lambda {@user_email.present?},
    :message => "with given email was not found"
  }
  validate do
    errors[:user] = 'cannot be yourself' if user_id == domain.user_id
  end
  
  def user_email
    @user_email || user.try(:email)
  end
  
  def user_email=(email)
    @user_email = email
    self.user = User.find_by_email(email)
  end
  
  def to_label
    user.try(:email) || @user_email || '-'
  end
end