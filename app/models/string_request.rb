class StringRequest < ApplicationRecord

  scope :reverse_chronological, -> { order(created_at: :desc) }

  def food
    FoodService.food_from_strings(
      upc || 9999,
      nutrition_facts_string || "",
      ingredients_string || "",
      false # create_record: false
    )
  end
end
