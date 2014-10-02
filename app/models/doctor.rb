class Doctor < ActiveRecord::Base
  attr_accessible :name
  has_many :accessions, :dependent => :nullify

  default_scope :order => :name

  validates_presence_of :name
  validates_uniqueness_of :name

  before_save :purge_trailing_spaces

  named_scope :limit, lambda { |limit| {:limit => limit} }
  named_scope :search_for_name, lambda { |term| {:conditions => ['lower(name) LIKE ?', "%#{term.try(:downcase)}%"]} }

private

  def purge_trailing_spaces
    self.name = name.squeeze(' ').strip if name
  end

end
