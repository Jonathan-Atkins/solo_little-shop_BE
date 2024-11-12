require 'rails_helper'

RSpec.describe "Merchant Coupon Endpoint", type: :request do
  describe "Happy Paths" do
    it "returns a specific Merchant coupon" do
      merchant1 = create(:merchant)
      coupon1 = create(:coupon, merchant: merchant1)

      get "/api/v1/merchants/#{merchant1.id}/coupons/#{coupon1.id}"

      coupon = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response).to be_successful
      expect(coupon[:id]).to eq(coupon1.id.to_s)
      expect(coupon[:type]).to eq("coupon")
      expect(coupon[:attributes][:name]).to eq(coupon1.name)
      expect(coupon[:attributes][:code]).to eq(coupon1.code)
      expect(coupon[:attributes][:value]).to eq(coupon1.value)
    end

    it "returns all coupons for a specific merchant" do
      merchant = create(:merchant)
      coupon1 = create(:coupon, merchant: merchant)
      coupon2 = create(:coupon, merchant: merchant)

      get "/api/v1/merchants/#{merchant.id}/coupons"

      coupons = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(coupons.size).to eq(2) 
      expect(coupons.first[:id]).to eq(coupon1.id.to_s)
      expect(coupons.second[:id]).to eq(coupon2.id.to_s)
    end

    it "creates a new coupon" do
      merchant1   = create(:merchant)
      coupon_info = { name: 'Quarter Off', code: '25OFF', value: 25 } 

      post "/api/v1/merchants/#{merchant1.id}/coupons", params: coupon_info

      coupon  = JSON.parse(response.body, symbolize_names: true)[:data]
      coupon1 = Coupon.last

      expect(response).to be_successful
      expect(coupon[:id]).to eq(coupon1.id.to_s)
      expect(coupon[:type]).to eq("coupon")
      expect(coupon[:attributes][:name]).to eq(coupon1.name)
      expect(coupon[:attributes][:code]).to eq(coupon1.code)
      expect(coupon[:attributes][:value]).to eq(coupon1.value)
    end

    it "deactivates a coupon" do
      merchant1 = create(:merchant)
      coupon1   = create(:coupon, merchant: merchant1)

      patch "/api/v1/merchants/#{merchant1.id}/coupons/#{coupon1.id}", params: { deactivate: true }

      coupon  = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to be_successful
      expect(coupon[:type]).to eq("coupon")
      expect(coupon[:attributes][:active]).to eq('inactive')
    end
  end
  
  describe "Sad Paths" do
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
end