class FoodService
  def self.food_from_strings(upc, nutrition_facts_string, ingredients_string)
    food = Food.new(name: 'Unnamed Food', upc: upc)
    food.nutrition_facts = nutrition_facts_from_string(nutrition_facts_string)
    food.ingredients = ingredients_from_string(ingredients_string)
    return food
  end

  def self.nutrition_facts_from_string(nutrition_facts_string)
    []
  end

  def self.ingredients_from_string(ingredients_string)
    Ingredient.by_name_composition_pairs(
      get_tentative_ingredients_from_string(ingredients_string).map {
        |t| [t.name, t.composition]
      }
    )
  end

  private
    def self.get_tentative_ingredients_from_string(ingredients_string)
      tentative_ingredients = []
      ingredients_string.gsub!("\n", "")
      ingredients_string = ingredients_string.titleize
      on_and_after_index = ingredients_string.index('INGREDIENTS:')
      ingredients_string = ingredient_string.slice(on_and_after_index, ingredients_string.length + 1) if on_and_after_index
      ingredients_string.gsub!('INGREDIENTS:', '')

      # remove trailing '.' if exists
      ingredients_string.chop! if ingredients_string.end_with?('.')

      ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
      ingredients_string.split('').each do |c|
        if ingredient.size > 0 && open_paren == close_paren && open_square == close_square && open_curly == close_curly && c == ','
          ingredient.strip!
          ingredient.chop! while ingredient.end_with?('*')
          ingredient.sub!('*', '') while ingredient.start_with?('*')
          ingredient.strip!

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
