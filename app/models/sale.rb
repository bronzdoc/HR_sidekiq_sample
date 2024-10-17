class Sale < ApplicationRecord
  validates :region, :country, :item_type, :channel,
    :order_date, :order_id, :units, :unit_price_in_cents,
    :total_revenue_in_cents, presence: true

  validates :units,
    :unit_price_in_cents,
    :total_revenue_in_cents,
    numericality: {greater_than_or_equal_to: 0, integer: true}

  def self.import_csv(file)
    require "csv"
    CSV.parse(file.strip, headers: true) do |row|
      return if row["Unit Price"].blank? || row["Total Revenue"].blank?

      # CSV headers
      #| Region | Country | Item Type | Sales Channel | Order Date | Order ID | Units Sold | Unit Price | Total Revenue |

      sales_hash = {}

      sales_hash[:region] = row["Region"]
      sales_hash[:country] = row["Country"]
      sales_hash[:item_type] = row["Item Type"]
      sales_hash[:channel] = row["Sales Channel"]
      sales_hash[:order_date] = row["Order Date"]
      sales_hash[:order_id] = row["Order ID"]
      sales_hash[:units] = row["Units Sold"]
      sales_hash[:unit_price_in_cents] = (100  * row["Unit Price"].to_r).to_i
      sales_hash[:total_revenue_in_cents] = ( 100 * row["Total Revenue"].to_r).to_i

       sale = new(sales_hash)
       sale.save if sale.valid?
    end

  end
end
