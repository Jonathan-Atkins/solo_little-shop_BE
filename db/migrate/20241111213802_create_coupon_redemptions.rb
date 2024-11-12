class CreateCouponRedemptions < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_redemptions do |t|
      t.references :coupon, null: false, foreign_key: true
      t.datetime :redeemed_at, null: false 
      t.timestamps
    end
  end
end