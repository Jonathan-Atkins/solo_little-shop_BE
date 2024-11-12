require "rails_helper"

RSpec.describe "Merchant invoices endpoints" do
  before :each do
    @merchant2 = Merchant.create!(name: "Merchant")
    @merchant1 = Merchant.create!(name: "Merchant Again")

    @customer1 = Customer.create!(first_name: "Papa", last_name: "Gino")
    @customer2 = Customer.create!(first_name: "Jimmy", last_name: "John")

    @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "packaged")
    Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped")
    Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped")
    Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped")
    @invoice2 = Invoice.create!(customer: @customer1, merchant: @merchant2, status: "shipped")
  end

  it "should return all invoices for a given merchant based on status param" do
    get "/api/v1/merchants/#{@merchant1.id}/invoices?status=packaged"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(1)
    expect(json[:data][0][:id]).to eq(@invoice1.id.to_s)
    expect(json[:data][0][:type]).to eq("invoice")
    expect(json[:data][0][:attributes][:customer_id]).to eq(@customer1.id)
    expect(json[:data][0][:attributes][:merchant_id]).to eq(@merchant1.id)
    expect(json[:data][0][:attributes][:status]).to eq("packaged")
  end

  it "should get multiple invoices if they exist for a given merchant and status param" do
    get "/api/v1/merchants/#{@merchant1.id}/invoices?status=shipped"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(3)
  end

  it "should only get invoices for merchant given" do
    get "/api/v1/merchants/#{@merchant2.id}/invoices?status=shipped"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data].count).to eq(1)
    expect(json[:data][0][:id]).to eq(@invoice2.id.to_s)
  end

  it "should return 404 and error message when merchant is not found" do
    get "/api/v1/merchants/100000/customers"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:not_found)
    expect(json[:message]).to eq("Your query could not be completed")
    expect(json[:errors]).to be_a Array
    expect(json[:errors].first).to eq("Couldn't find Merchant with 'id'=100000")
  end

  it "returns a merchants invoices, including the coupon id if one was used" do
    merchant3 = Merchant.create!(name: "Amazon")
    coupon1 = Coupon.create!(name: "DISCOUNT10", code: "DISC10", value: 10, merchant: merchant3)
    coupon2 = Coupon.create!(name: "DISCOUNT20", code: "DISC20", value: 20, merchant: merchant3)
    
    
    invoice_with_coupon1 = Invoice.create!(customer: @customer1, merchant: merchant3, status: "shipped", coupon: coupon1)
    invoice_with_coupon2 = Invoice.create!(customer: @customer2, merchant: merchant3, status: "shipped", coupon: coupon2)
    invoice_without_coupon = Invoice.create!(customer: @customer2, merchant: merchant3, status: "shipped")
  
    get "/api/v1/merchants/#{merchant3.id}/invoices"
  
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(invoices.count).to eq(3)

    invoice_data = invoices.first
    expect(invoice_data[:attributes][:coupon_id]).to eq(coupon1.id)

    invoice_data = invoices.second
    expect(invoice_data[:attributes][:coupon_id]).to eq(coupon2.id)
  
    invoice_data = invoices.third
    expect(invoice_data[:attributes][:coupon_id]).to be_nil
  end
end