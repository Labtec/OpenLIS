class Price < ActiveRecord::Base
  # Consider caching this model
  #attr_accessible :price_list_id, :amount

  belongs_to :price_list
  belongs_to :priceable, :polymorphic => true

  validates_numericality_of :amount
  validate :positive_amount
  validates_presence_of :price_list_id
  validates_presence_of :priceable_id
  validates_presence_of :priceable_type

private

  def positive_amount
    errors.add(:amount, "should be at least 0.00") if amount.nil? || amount < 0.00
  end
end
