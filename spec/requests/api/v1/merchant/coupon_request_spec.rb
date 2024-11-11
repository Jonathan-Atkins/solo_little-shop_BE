require 'rails_helper'

RSpec.describe "Merchant Coupon Endpoint", type: :request do
  it "returns a specific Merchant coupon" do
    merchant1 = create(:merchant)
    coupon1 = create(:coupon, merchant: merchant1)

    get "/api/v1/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data][:id]).to eq(coupon1.id.to_s)
    expect(json[:data][:type]).to eq("coupon")
    expect(json[:data][:attributes][:name]).to eq(coupon1.name)
  end

  it "returns all coupons for a specific merchant" do
    merchant = create(:merchant)
    coupon1 = create(:coupon, merchant: merchant)
    coupon2 = create(:coupon, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/coupons"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].size).to eq(2) 
    expect(json[:data].first[:id]).to eq(coupon1.id.to_s)
    expect(json[:data].second[:id]).to eq(coupon2.id.to_s)
  end

  it "returns a 404 error if the merchant does not exist when fetching a coupon" do
    get "/api/v1/merchants/999999/coupons/1"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(json[:error]).to eq("Merchant not found")
  end

  it "returns a 404 error if the coupon does not exist for a merchant" do
    merchant1 = create(:merchant)

    get "/api/v1/merchants/#{merchant1.id}/coupons/999999"  

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(json[:error]).to eq("Coupon not found")
  end

  it "returns a 404 error if the merchant does not exist when fetching all coupons" do
    get "/api/v1/merchants/999999/coupons" 

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(json[:error]).to eq("Merchant not found")
  end

it "returns a 404 error if no coupons exist for a merchant" do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}/coupons"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(json[:error]).to eq("Coupons not found")
  end
end