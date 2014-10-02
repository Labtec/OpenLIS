class AccessionPanel < ActiveRecord::Base
  belongs_to :accession
  belongs_to :panel
end
