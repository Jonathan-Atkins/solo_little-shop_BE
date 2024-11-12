class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum active: { inactive: 0, active: 1 }

  validates :name, :value, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  
  before_validation :downcase_code
  
  def usage_count
    redemptions.count
  end

  def de_eligible?(deactivate)
    invoices.empty? && deactivate == 'true'   
  end

  def eligible?(activate)
    self.merchant.coupons.where(active: :active).count < 5 && activate == 'false'   
  end

  def usage_count
    redemptions_count || 0
  end

  def increment_redemptions
    update(redemptions_count: usage_count + 1)
  end
  
  private

  def downcase_code
    self.code = code.downcase if code.present?
  end
end