class Domain < ActiveRecord::Base
  
  validate :domain_ownership
  def domain_ownership
    # non-TLD validation
    errors[:name] = "cannot be a TLD or a reserved domain" if Tld.include?(name)

    # If parent domain is on our system, the user be permitted to manage current domain.
    # He either owns parent, or is permitted to current domain or to an ancestor.
    if parent_domain.present? && !parent_domain.can_be_managed_by_current_user?
      @domain_ownership_failed = true
      errors[:name] = "issue, the parent domain `#{parent_domain.name}` is registered to another user"
    end
  end
    
  # If current user present authorize it
  # If current user not present, just allow (rake tasks etc)
  def can_be_managed_by_current_user?
    return true if User.current.nil?
    Ability::CRUD.all?{|operation| User.current.can?(operation, self)}
  end
  
  before_save do
    self.name_reversed = name.reverse if name_changed?
  end
  
  # Returns the first immediate parent, if exists (and caches the search)
  def parent_domain
    return nil if name.nil?
    @parent_domain ||= {}
    @parent_domain[name] ||= _parent_domain
  end
  
  def subdomains
    Domain.where(:name_reversed.matches => "#{name_reversed}.%")
  end
  
  protected

  # Returns the first immediate parent, if exists (does not cache the search)
  # For example "sub.sub.domain.com"'s parent might be "sub.domain.com" or "domain.com"
  def _parent_domain
    segments = name.split('.')
    while segments.size > 1
      segments.shift
      domain = Domain.find_by_name(segments.join('.'))
      return domain if domain.present?
    end
    return nil
  end
  
end