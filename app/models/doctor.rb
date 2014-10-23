class Doctor < ActiveRecord::Base
  has_many :accessions, inverse_of: :doctor, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name

  before_save :purge_trailing_spaces

  scope :search_for_name, ->(term) { where(['lower(name) LIKE ?', "%#{term.try(:downcase)}%"]) }

  default_scope { order(name: :asc) }

private

  def purge_trailing_spaces
    self.name = name.squish if name
  end
end
