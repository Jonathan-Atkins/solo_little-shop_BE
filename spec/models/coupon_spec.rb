require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it { should belong_to :merchant }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:value) }
  it { should have_many(:invoices) }

  let(:merchant){ create(:merchant) }
  
  #* subject creates a new valid coupon. It is automatically going to create two versions of that coupon
  #* my it line determines if there is uniqueness and case insensitivity between the the attribute that we are looking at(code in this instance)
  subject { Coupon.create!(name: 'Black Friday', code: 'BF2024', value: 20, merchant: merchant) }
  it { should validate_uniqueness_of(:code).case_insensitive }

  it "counts the number of coupon redemptions" do
    merchant = create(:merchant)
    coupon = create(:coupon, merchant: merchant)

    create_list(:coupon_redemption, 3, coupon: coupon)  
    expect(coupon.usage_count).to eq(3)
  end
end