require "swagger_helper"

RSpec.describe "Inventory API", type: :request do
  # GET ALL
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
              price: { type: :number, format: :float },
              created_at: { type: :string },
              updated_at: { type: :string }
            },
            required: %w[id name quantity price]
          }
        run_test!
      end
    end
  end

  # CREATE
  path "/products" do
    post("Create a product") do
      tags "Products"
      consumes "application/json"
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          quantity: { type: :integer },
          price: { type: :number, format: :float }
        },
        required: %w[name quantity price]
      }

      let(:product) { { name: "Test Product", quantity: 10, price: 50.0 } }

      response(201, "created") do
        schema type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          quantity: { type: :integer },
          price: { type: :number, format: :float }
        },
        required: %w[id name quantity price]

        run_test! do | response |
          product = JSON.parse.body(response.body)
          expect(product["name"]).to eq("Test Product")
        end
      end

      response(422, "unprocessable entity") do
        let(:product) { { name: "Test Product", quantity: -1, price: 50.0 } }
        run_test!
      end
    end
  end

  # READ
  path "/products/{id}" do
    get("Get a product by id") do
      tags "Products"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer

      let(:id) { 1 }

      response(200, "success") do
        schema type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          quantity: { type: :integer },
          price: { type: :number, format: :float }
        },
        required: %w[id name quantity price]

        run_test!
      end

      response(404, "not found") do
        let(:id) { 999999 }
        run_test!
      end
    end
  end

  # UPDATE
  path "/products/{id}" do
    put("Update product") do
      tags "Products"
      consumes "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          quantity: { type: :integer },
          price: { type: :number, format: :float }
        },
        required: %w[name quantity price]
      }

      let(:id) { 1 }
      let(:product) { { name: "Updated product", quantity: 5, price: 9.99 } }

      response(200, "success") do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            quantity: { type: :integer },
            price: { type: :number, format: :float }
          },
          required: %w[id name quantity price]

        run_test!
      end

      response(404, "not found") do
        let(:id) { 9999 }
        let (:product) { { name: "Updated product", quantity: 5, price: 9.99 } }

        run_test!
      end
    end
  end

  # DELETE
  path "/products/{id}" do
    delete("Delete a product") do
      tags "Products"
      parameter name: :id, in: :path, type: :integer

      response(204, "no content") do
        let(:id) { 1 }
        run_test!
      end

      response(404, "not found") do
        let(:id) { 9999 }
        run_test!
      end
    end
  end
end
