RSpec.describe Coupon, type: :model do
  it { should belong_to :merchant }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:value) }

  it "counts the number of coupon redemptions" do
    merchant = create(:merchant)
    coupon = create(:coupon, merchant: merchant)

    create_list(:coupon_redemption, 3, coupon: coupon)  
    expect(coupon.usage_count).to eq(3)
  end
end