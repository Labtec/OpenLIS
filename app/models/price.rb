class Price < ActiveRecord::Base
  # Consider caching this model
  #attr_accessible :price_list_id, :amount

  belongs_to :price_list, inverse_of: :prices
  belongs_to :priceable, polymorphic: true

  validates :amount, numericality: true
  validates :price_list_id, presence: true
  validates :priceable_id, presence: true, uniqueness: { scope: :price_list_id }
  validates :priceable_type, presence: true
  validate :positive_amount

private

  def positive_amount
    errors.add(:amount, "should be at least 0.00") if amount.nil? || amount < 0.00
  end
end
