class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :code, :value, :active

    attribute :usage_count do |coupon|
        coupon.usage_count
    end
end