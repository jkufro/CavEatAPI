module Api
  module V1
    class FoodsController < ApiController
      skip_before_action :verify_authenticity_token
      before_action :set_food_upc, only: [:show_by_upc]
      before_action :set_food_strings, only: [:show_by_strings]

      swagger_controller :foods, "Foods Retrieval"

      swagger_api :show_by_upc do
        summary "Fetches a food by UPC."
        notes "This takes in a product's UPC and returns the Food object with its associated Nutrition Facts and Ingredients."
        param :upc, :integer, :required, "Product UPC"
        response :not_found, I18n.t('api.vi.foods.not_found')
      end

      def show_by_upc
        if @food
          render json: FoodSerializer.new(@food, serialize_options).serialized_json
        else
          render json: { message: I18n.t('api.vi.foods.not_found') }, status: :not_found
        end
      end

      swagger_api :show_by_strings do
        summary "Returns a new food constructed from strings."
        notes "This takes in two OCR strings: a product's Nutrition Facts and Ingredients. It returns a new Food object with its associated Nutrition Facts and Ingredients."
        param :upc, :integer, :required, "Product UPC"
        param :nutrition_facts, :string, :required, "OCR of Nutrition Facts label"
        param :ingredients, :string, :required, "OCR of Ingredients label"
        response :not_found, I18n.t('api.vi.foods.not_found')
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
          @food = Food.eager_load(:ingredients).eager_load(nutrition_facts: :nutrient).find_by_upc(show_by_upc_params[:upc])
        end

        def set_food_strings
          pms = show_by_strings_params
          return unless pms[:nutrition_facts] && pms[:ingredients] && pms[:nutrition_facts].is_a?(String) && pms[:ingredients].is_a?(String)
          @food = FoodService.food_from_strings(pms[:upc], pms[:nutrition_facts], pms[:ingredients])
        end
    end
  end
end
