# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2020_05_23_081056) do
  create_table "sales", force: :cascade do |t|
    t.string "region"
    t.string "country"
    t.string "item_type"
    t.string "channel"
    t.date "order_date"
    t.string "order_id"
    t.integer "units"
    t.integer "unit_price_in_cents"
    t.integer "total_revenue_in_cents"
  end

end
