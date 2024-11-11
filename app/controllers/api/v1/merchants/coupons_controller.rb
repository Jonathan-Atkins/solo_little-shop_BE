class Api::V1::Merchants::CouponsController < ApplicationController
  before_action :set_merchant

  def show
    coupon = @merchant.coupons.find_by(id: params[:id])
    if coupon
      render json: CouponSerializer.new(coupon)
    else
      render json: { error: "Coupon not found" }, status: :not_found
    end
  end

  def index
    coupons = @merchant.coupons
    if coupons.empty?
      render json: { error: "Coupons not found" }, status: :not_found
    else
      render json: CouponSerializer.new(coupons)
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_by(id: params[:merchant_id])
    render json: { error: "Merchant not found" }, status: :not_found unless @merchant
  end
end