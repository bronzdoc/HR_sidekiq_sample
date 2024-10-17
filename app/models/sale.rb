class Sale < ApplicationRecord
  validates :region, :country, :item_type, :channel,
    :order_date, :order_id, :units, :unit_price_in_cents,
    :total_revenue_in_cents, presence: true

  validates :units,
    :unit_price_in_cents,
    :total_revenue_in_cents,
    numericality: {greater_than_or_equal_to: 0, integer: true}
end
