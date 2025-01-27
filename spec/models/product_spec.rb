require 'rails_helper'

RSpec.describe Product, type: :model do
  it "is valid with valid attributes" do
    product = Product.new(name: "Item 01", quantity: 10, price: 5.99)
    expect(product).to be_valid
  end

  it "is not valid without a name" do
    product = Product.new(name: nil, quantity: 10, price: 5.99)
    expect(product).to_not be_valid
  end
end
