class Domain < ActiveRecord::Base
  set_inheritance_column "sti_disabled"
  nilify_blanks
  stampable

  # optional IP for create form, results in a type A record
  attr_accessor :ip
  
  belongs_to :user, :inverse_of => :domain
  has_many :records, :inverse_of => :domain, :dependent => :destroy
  has_many :permissions, :inverse_of => :domain, :dependent => :destroy
  has_many :permitted_users, :through => :permissions, :source => :user

  cattr_reader :types
  @@types = ['NATIVE', 'MASTER', 'SLAVE', 'SUPERSLAVE']
  
  has_one :soa_record,
    :class_name => 'SOA', 
    :conditions => {:type => 'SOA'},
    :inverse_of => :domain
  
  for type in Record.types
    has_many :"#{type.downcase}_records", 
      :class_name => type, 
      :conditions => {:type => type},
      :inverse_of => :domain
    validates_associated :"#{type.downcase}_records"
  end
  
  validates :name, :presence => true, :uniqueness => true, :domainname => {:require_valid_tld => false}
  validates :master, :presence => true, :if => :slave?
  validates :master, :ip => true, :allow_nil => true, :if => :slave?
  validates :type, :inclusion => { :in => @@types, :message => "Unknown domain type" }
  validates :soa_record, :presence => {:unless => :slave?}
  validates_associated :soa_record #, :allow_nil => true
  validates :ns_records, :on => :create, :presence => true, :length => {
    :minimum => 2, :maximum => 10, :message => "must have be at least 2, at most 10"}
  validates_associated :records
  validates :user_id, :presence => true
  
  validate :max_domains_per_user, :on => :create
  def max_domains_per_user # domains per user limit for DOS protection
    max = Settings.max_domains_per_user.to_i
    if user.domains.count >= max
      errors.add :base, "as a security measure, you cannot have more than #{max} domains on one account"
    end
  end

  validate :domain_ownership
  def domain_ownership
    # non-TLD validation
    errors[:name] = "cannot be a TLD or a reserved domain" if Tld.include?(name)

    # If parent domain is on our system, the user be permitted to manage current domain.
    # He either owns parent, or is permitted to current domain or to an ancestor.
    if parent_domain.present? && can_be_managed_by_current_user?
      errors[:name] = "issue, the parent domain `#{parent_domain.name}` is registered to another user"
    end
  end
  
  def parent_domain
    return nil if name.nil?
    @parent_domain ||= {}
    @parent_domain[name] ||= begin
      segments = name.split('.')
      if segments.size >= 2
        domain_name = segments[1..-1].join('.')
        Domain.find_by_name(domain_name)
      else
        nil
      end
    end
  end
  
  # If current user present authorize it
  # If current user not present, just allow (rake tasks etc)
  def can_be_managed_by_current_user?
    User.current.present? ? User.current.can?(:manage, self) : true
  end
  
  def slave?; self.type == 'SLAVE' end

  before_create do
    a_records.build(:content => ip) if ip.present?
  end
  
  before_save do
    self.name_reversed = name.reverse if name_changed?
  end
  
  before_validation(:on => :update) do
    if name_changed?
      name_was_pattern = /#{Regexp.escape(name_was)}$/
      each_update_involved_record do |record|
        if record.type == 'SOA'
          record.reset_serial
          record.name = name
        else
          record.name = record.name.sub(name_was_pattern, name)
        end
        record.domain = self
      end
    end
  end

  after_update do
    if name_changed?
      name_was_pattern = /#{Regexp.escape(name_was)}$/
      for record in records.all
        record.name = record.name.sub(name_was_pattern, name)
        record.save!
      end
    end
  end
  
  def each_update_involved_record
    yield soa_record
    for record in soa_records
      yield record
    end
    for record in records
      yield record
    end
  end

  scope :host_domains, where(:name => Settings.host_domains)
  
  def subdomains
    Domain.where(:name_reversed.matches => "#{name_reversed}.%")
  end
  
  def host_domain?
    Settings.host_domains.include?(name)
  end
  
  # domain.has_ns?('129.168.0.1')
  def has_ns?(ns)
    ns_records.any? {|ns_record| ns_record.content == ns}
  end
  
  def setup(email)
    build_soa_record
    soa = soa_record
    soa.contact ||= email

    ns_records.build
    ns_records.build
    ns_records.build
    ns1, ns2, ns3 = ns_records
    ns1.content = Settings.ns.first
    ns2.content = Settings.ns.second
    ns3.content = Settings.ns.third
  end
end
