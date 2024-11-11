class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :code, :value

    attribute :usage_count do |coupon|
        coupon.usage_count
    end
end