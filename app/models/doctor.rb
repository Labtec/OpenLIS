class Doctor < ActiveRecord::Base
  has_many :accessions, :dependent => :nullify

  validates_presence_of :name
  validates_uniqueness_of :name

  before_save :purge_trailing_spaces

  #scope :limit, lambda { |limit| {:limit => limit} }
  #scope :search_for_name, lambda { |term| {:conditions => ['lower(name) LIKE ?', "%#{term.try(:downcase)}%"]} }

  default_scope { order(name: :asc) }

private

  def purge_trailing_spaces
    self.name = name.squeeze(' ').strip if name
  end

end
