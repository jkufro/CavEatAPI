module Api
  module V1
    class FoodsController < ApiController
      include Swagger::Blocks

      skip_before_action :verify_authenticity_token
      before_action :set_food_upc, only: [:show_by_upc]
      before_action :set_food_strings, only: [:show_by_strings]

      swagger_path '/v1/upc' do
        operation :post do
          key :summary, "Fetches a food by UPC."
          key :description, "This takes in a product's UPC and returns the Food object with its associated Nutrition Facts and Ingredients."
          key :operationId, 'showByUpc'
          key :tags, [
            'Foods'
          ]
          parameter do
            key :name, 'UPC'
            key :in, :body
            key :description, 'Request Body'
            key :required, true
            schema do
              key :type, :object
              key :required, [:upc]
              property :upc do
                key :type, :integer
                key :format, :int64
                key :description, "Product UPC"
                key :example, "85239233450"
              end
            end
          end
          response 200 do
            key :description, 'Food response.'
          end
          response 404 do
            key :description, I18n.t('api.vi.foods.not_found')
          end
        end
      end

      swagger_path '/v1/strings' do
        operation :post do
          key :summary, "Fetches a food by OCR strings."
          key :description, "This takes in two OCR strings: a product's Nutrition Facts and Ingredients. It returns a new Food object with its associated Nutrition Facts and Ingredients."
          key :operationId, 'showByStrings'
          key :tags, [
            'Foods'
          ]

          parameter do
            key :name, 'UPC & OCR Strings'
            key :in, :body
            key :description, 'Request Body'
            key :required, true
            schema do
              key :type, :object
              key :required, [:nutrition_facts, :ingredients]
              property :upc do
                key :type, :integer
                key :format, :int64
                key :description, "Product UPC"
                key :example, "85239233450"
              end
              property :nutrition_facts do
                key :type, :string
                key :description, "OCR of Nutrition Facts label"
                key :example, "Protien 5g 11\% other extraneous text Sugars 15g"
              end
              property :ingredients do
                key :type, :string
                key :description, "OCR of Ingredients label"
                key :example, "High Fructose Corn Syrup other extraneous text Water"
              end
            end
          end
          response 200 do
            key :description, 'Food response.'
          end
          response 404 do
            key :description, I18n.t('api.vi.foods.not_found')
          end
        end
      end

      def show_by_upc
        if @food
          render json: FoodSerializer.new(@food, serialize_options).serialized_json
        else
          render json: { message: I18n.t('api.vi.foods.not_found') }, status: :not_found
        end
      end

      def show_by_strings
        if @food
          render json: FoodSerializer.new(@food, serialize_options).serialized_json
        else
          render json: { message: I18n.t('api.vi.foods.not_found') }, status: :not_found
        end
      end

      private
        def serialize_options
          { meta: 1, include: [:ingredients, :nutrition_facts] }
        end

        def show_by_upc_params
          params.permit(:upc)
        end

        def show_by_strings_params
          params.permit(:upc, :nutrition_facts, :ingredients)
        end

        def set_food_upc
          @food = Food.includes([:ingredients, nutrition_facts: :nutrient]).find_by_upc(show_by_upc_params[:upc])
        end

        def set_food_strings
          pms = show_by_strings_params
          return unless pms[:nutrition_facts] && pms[:ingredients] && pms[:nutrition_facts].is_a?(String) && pms[:ingredients].is_a?(String)
          @food = FoodService.food_from_strings(pms[:upc], pms[:nutrition_facts], pms[:ingredients])
        end
    end
  end
end
