class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.string :region
      t.string :country
      t.string :item_type
      t.string :channel
      t.date :order_date
      t.string :order_id
      t.integer :units
      t.integer :unit_price_in_cents
      t.integer :total_revenue_in_cents
    end
  end
end

