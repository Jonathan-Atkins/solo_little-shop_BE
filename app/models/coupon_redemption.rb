class CouponRedemption < ApplicationRecord
  belongs_to :coupon

  validates :coupon_id, presence: true
  validates :redeemed_at, presence: true 
end