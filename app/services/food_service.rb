class FoodService
  def self.food_from_strings(upc, nutrition_facts_string, ingredients_string)
    food = Food.new(name: 'Unnamed Food', upc: upc)
    food.nutrition_facts = nutrition_facts_from_string(nutrition_facts_string)
    food.ingredients = ingredients_from_string(ingredients_string)
    return food
  end

  def self.nutrition_facts_from_string(nutrition_facts_string)
    found_nutrition_facts = []
    nutrition_facts_string.gsub!("\n", " ")
    nutrition_facts_string.gsub!(/\d{1,3}%/, '')
    nutrition_facts_string.downcase!
    available_nutrients = Nutrient.all

    dummy_id = 1  # required for fastjson to serialize

    available_nutrients.each do |nutrient|
      start_index = nutrition_facts_string.index(nutrient.name.downcase)
      if start_index
        start_index += nutrient.name.length
        amount = get_amount_from_string(nutrition_facts_string, start_index, nutrient.unit.downcase)
        next unless amount
        nutrition_fact = NutritionFact.new(
          id: dummy_id,
          nutrient_id: nutrient.id,
          amount: amount
        )
        dummy_id += 1
        found_nutrition_facts << nutrition_fact if nutrition_fact
      end
    end

    return found_nutrition_facts
  end

  def self.ingredients_from_string(ingredients_string)
    Ingredient.by_name_composition_pairs(
      get_tentative_ingredients_from_string(ingredients_string).map {
        |t| [t.name, t.composition]
      }
    )
  end

  private
    def self.get_amount_from_string(nutrition_facts_string, start_index, unit)
      nutrition_facts_string.slice(start_index, nutrition_facts_string.length + 1).match(/^\s*<?(\d+(.\d+)?)#{unit}/)&.captures&.first&.to_i
    end

    def self.get_tentative_ingredients_from_string(ingredients_string)
      tentative_ingredients = []
      ingredients_string.gsub!("\n", " ")
      ingredients_string = ingredients_string.titleize
      on_and_after_index = ingredients_string.index('Ingredients:')
      ingredients_string = ingredients_string.slice(on_and_after_index, ingredients_string.length + 1) if on_and_after_index
      ingredients_string.gsub!('Ingredients:', '')

      # remove trailing '.' if exists
      ingredients_string.chop! if ingredients_string.end_with?('.')

      ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
      ingredients_string.split('').each do |c|
        if ingredient.size > 0 && open_paren == close_paren && open_square == close_square && open_curly == close_curly && (c == ',' || c == '.' || c == ';')
          tentative_ingredients << build_ingredient_from_string(ingredient)

          ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
          next
        end
        open_paren += 1 if c == '('
        close_paren += 1 if c == ')'
        open_square += 1 if c == '['
        close_square += 1 if c == ']'
        open_curly += 1 if c == '{'
        close_curly += 1 if c == '}'
        ingredient += c
      end

      tentative_ingredients << build_ingredient_from_string(ingredient)

      return tentative_ingredients
    end

    def self.build_ingredient_from_string(ingredient_string)
      # cleanup string
      ingredient_string.strip!
      ingredient_string.chop! while ingredient_string.end_with?('*')
      ingredient_string.sub!('*', '') while ingredient_string.start_with?('*')
      ingredient_string.chop! while ingredient_string.end_with?('.')
      ingredient_string.chop! while ingredient_string.end_with?('*')
      ingredient_string.strip!
      ingredient_string = ingredient_string.titleize

      # split up the name and composition based on first (, {, or [
      split_index = [ingredient_string.index('('), ingredient_string.index('{'), ingredient_string.index('[')].compact.min
      ingredient_name = split_index ? ingredient_string.slice(0, split_index) : ingredient_string
      ingredient_composition = split_index ? ingredient_string.slice(split_index, ingredient_string.length + 1) : ''

      return Ingredient.new(
        name: ingredient_name.strip.titleize,
        composition: ingredient_composition.strip.titleize
      )
    end
end
