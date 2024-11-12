class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :coupon_redemptions 
    has_many :invoices
  
    validates :name, presence: true
    validates :value, presence: true
    before_validation :downcase_code

    validates :code, presence: true, uniqueness: { case_sensitive: false }
    enum active: { inactive: 1, active: 0 }
    
    def usage_count
      coupon_redemptions.count
    end

    def eligible?(deactivate)
      invoices.empty? && self.merchant.coupons.where(active: :active).count <= 5 && deactivate == 'true'   
    end

    private

    def downcase_code
      self.code = code.downcase if code.present?
    end
    
  end