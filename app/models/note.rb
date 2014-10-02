class Note < ActiveRecord::Base
  #attr_protected :id
  belongs_to :department
  belongs_to :noticeable, :polymorphic => true
end
