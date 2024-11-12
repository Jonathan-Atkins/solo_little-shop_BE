class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :status, inclusion: { in: ["shipped", "packaged", "returned"] }

  def self.format_invoices(invoices)
    invoices.map do |invoice|
      {
        id: invoice.id.to_s,
        type: "invoice",
        attributes: {
          customer_id: invoice.customer.id,
          merchant_id: invoice.merchant.id,
          coupon_id: invoice.coupon_id,
          status: invoice.status
        }
      }
    end
  end

  def coupon_id
    coupon ? coupon.id : nil
  end
end