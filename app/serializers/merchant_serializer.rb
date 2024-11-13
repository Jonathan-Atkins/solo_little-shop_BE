class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name, :item_count, :coupons_count, :invoice_coupon_count
end
