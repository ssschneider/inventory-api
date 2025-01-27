require "swagger_helper"

RSpec.describe "Inventory API", type: :request do
  path "/products" do
    get("List all products") do
      tags "Products"
      produces "application/json"

      response(200, "success") do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              quantity: { type: :integer },
              price: { type: :decimal },
              created_at: { type: :string },
              updated_at: { type: :string },
            },
            required: %w[id name quantity price]
          }
        run_test!
      end
    end
  end
end
