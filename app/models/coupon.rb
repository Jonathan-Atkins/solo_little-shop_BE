class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :coupon_redemptions 
  
    validates :name, presence: true
    validates :code, presence: true
    validates :value, presence: true
  
    def usage_count
      coupon_redemptions.count
    end
  end