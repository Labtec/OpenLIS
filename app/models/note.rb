class Note < ApplicationRecord
  belongs_to :department, inverse_of: :notes
  belongs_to :noticeable, polymorphic: true
end
