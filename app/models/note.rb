class Note < ActiveRecord::Base
  belongs_to :department
  belongs_to :noticeable, :polymorphic => true
end
