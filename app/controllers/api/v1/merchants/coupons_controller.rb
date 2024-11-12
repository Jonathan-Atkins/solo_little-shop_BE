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
    if params[:active].present?
      if params[:active] == 'true'
        coupons = coupons.where(active: 1)
        elsif params[:active] == 'false'
          coupons = coupons.where(active: 0)
    end
  end
    
  if coupons.empty?
      render json: { error: "Coupons not found" }, status: :not_found
    else
      render json: CouponSerializer.new(coupons)
    end
  end

  def create
    begin
      new_coupon = @merchant.coupons.create(coupon_params)
      render json: CouponSerializer.new(new_coupon), status: :created
    rescue  ActiveRecord::RecordInvalid => exception
      render json: ErrorSerializer.format_error(exception), status: :unproccessable_entity
    end
  end

  def update
    coupon = @merchant.coupons.find(params[:id])
    if coupon.de_eligible?(params[:deactivate])
      coupon.update!(active: 0)
      render json: CouponSerializer.new(coupon)
    elsif coupon.eligible?(params[:deactivate])
      coupon.update!(active: 1)
      render json: CouponSerializer.new(coupon)
    else
      render json: { error: "Coupon not found" }, status: :not_found  
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_by(id: params[:merchant_id])
    render json: { error: "Merchant not found" }, status: :not_found unless @merchant
  end

  def coupon_params
    params.permit(:name, :code, :value)
  end
  
end