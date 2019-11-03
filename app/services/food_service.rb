class FoodService
  def self.food_from_strings(upc, nutrition_facts_string, ingredients_string, create_record=true)
    StringRequest.create(
      upc: upc,
      nutrition_facts_string: nutrition_facts_string,
      ingredients_string: ingredients_string
    ) if create_record
    food = Food.new(id: 1, name: 'Unnamed Food', upc: upc || 1)
    return food if nutrition_facts_string.nil? || nutrition_facts_string.strip == ""
    return food if ingredients_string.nil? || ingredients_string.strip == ""
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

  def self.get_tentative_ingredients_from_string(ingredients_string)
    tentative_ingredients = []
    ingredients_string.strip!
    ingredients_string = ingredients_string.downcase
    ingredients_string.gsub!("\n", " ")
    ingredients_string.gsub!(/[†‡*¬∞]/, '')
    ingredients_string.gsub!(/\(?(added\s+)?(as\s+)?(a\s+)?(color\s+)?preservative(s)?\)?/, '')
    ingredients_string.gsub!('(to retain color)', '')
    ingredients_string.gsub!(/\"?\(?(added\s+)?to\s+protect\s+flavor\)?\.?"?/, '')
    ingredients_string.gsub!('(alkali process)', '')
    ingredients_string.gsub!('(an emulsifier)', '')
    ingredients_string.gsub!('(an artificial flavor)', '')
    ingredients_string.gsub!(/\(?(as\s+)?(contains+)?an enzyme(\s+additive)?\)?/, '')
    ingredients_string.gsub!(/\(?(added\s+)?to promote color retention\)?/, '')
    ingredients_string.gsub!('(retains product freshness)', '')
    ingredients_string.gsub!(/\(?a natural antioxidant\)?/, '')
    ingredients_string.gsub!('to maintain freshness', '')
    ingredients_string.gsub!(/\"?\(?to preserve freshness\)?\.?"?/, '')
    ingredients_string.gsub!(/\"?\(?to preserve flavor\)?\.?"?/, '')
    ingredients_string.gsub!(/[\(\){}\[\]]/, ',')
    ingredients_string.gsub!('‚', ",")
    ingredients_string.gsub!(' and/or ', ',')
    ingredients_string.gsub!(/<?(\d{1,})?[\.,]?\d{1,}\s?(%|(g)|(mg\/kg)|(mg\/\s*fl\s*oz)|(mg)|(ml)|(\s*fl\s*oz))/, '')
    ingredients_string.gsub!(/\d+\/\d+(\s*th)? (of|0f)?/, '')
    ingredients_string.gsub!(/\d+\s+percent/, '')
    ingredients_string.gsub!(/(contains\s+)?(or\s+)?\bless\s+(than\s+)?(percent)?(of\s+)?/, '')
    ingredients_string.gsub!(' or ', ',')
    ingredients_string.gsub!(/['"]00['"]/, '00')
    ingredients_string.gsub!(/\bnos?\./, 'no')
    # ingredients_string.gsub!(/contains \d% or less of[ :]/, '')
    # ingredients_string.gsub!(/contains \d% or less(:|( -))/, '')
    # ingredients_string.gsub!(/contains less than \d% ?(of)?:? ?/, '')
    # ingredients_string.gsub!(/(and )?less than \d%( of( the following:? |: )?|:)?/, '')
    # ingredients_string.gsub!(/\d% or less of (the following:? )?/, '')
    # ingredients_string.gsub!(/contains \w+ percent or less of:?/, '')
    # ingredients_string.gsub!(/(\d{1,3}\.)?\d{1,3}\s?%/, '')
    ingredients_string.gsub!(/(?<!\w)([a-zA-Z])\./, '\\1')
    ingredients_string.gsub!(/\s{2,}/, ' ')
    on_and_after_index = ingredients_string.index('ingredients:')
    ingredients_string = ingredients_string.slice(on_and_after_index, ingredients_string.length + 1) if on_and_after_index
    ingredients_string.strip!

    ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
    ingredients_string.split('').each do |c|
      if open_paren == close_paren && open_square == close_square && open_curly == close_curly && (c == ',' || c == '.' || c == ';')
        new_ingredient = build_ingredient_from_string(ingredient)
        tentative_ingredients << new_ingredient if new_ingredient.name.length > 1 && /[a-zA-Z]/.match?(ingredient)

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

    new_ingredient = build_ingredient_from_string(ingredient)
    tentative_ingredients << new_ingredient if new_ingredient.name.length > 1 && /[a-zA-Z]/.match?(ingredient)

    return tentative_ingredients
  end

  private
    def self.get_amount_from_string(nutrition_facts_string, start_index, unit)
      nutrition_facts_string.slice(start_index, nutrition_facts_string.length + 1).match(/^\s*<?(\d+(.\d+)?)#{unit}/)&.captures&.first&.to_f
    end
    def self.build_ingredient_from_string(ingredient_string)
      # cleanup string
      ingredient_string.strip!
      ingredient_string.gsub!(/.*:/, '')
      ingredient_string.gsub!(/(\w* )*((each of )|contains one or more of )?the following:? /, '')
      ingredient_string.chop! while ingredient_string.end_with?('!')
      ingredient_string.chop! while ingredient_string.end_with?('/')
      ingredient_string.chop! while ingredient_string.end_with?('"')
      ingredient_string.chop! while ingredient_string.end_with?('*')
      ingredient_string.chop! while ingredient_string.end_with?('+')
      ingredient_string.chop! while ingredient_string.end_with?('-')
      ingredient_string.chop! while ingredient_string.end_with?('.')
      ingredient_string.sub!('.', '') while ingredient_string.start_with?('.')
      ingredient_string.sub!('*', '') while ingredient_string.start_with?('*')
      ingredient_string.sub!('"', '') while ingredient_string.start_with?('"')
      ingredient_string.sub!('and ', '') while ingredient_string.start_with?('and ')
      ingredient_string.sub!('with ', '') while ingredient_string.start_with?('with ')
      ingredient_string.sub!('ingredients consist of ', '') if ingredient_string.start_with?('ingredients consist of ')
      ingredient_string.strip!

      # split up the name and composition based on first (, {, or [
      split_index = [ingredient_string.index('('), ingredient_string.index('{'), ingredient_string.index('[')].compact.min
      ingredient_name = split_index ? ingredient_string.slice(0, split_index) : ingredient_string
      ingredient_composition = split_index ? ingredient_string.slice(split_index, ingredient_string.length + 1) : ''

      return Ingredient.new(
        name: ingredient_name.strip,
        composition: ingredient_composition.strip
      )
    end



  # OLD BELOW
  # def self.get_tentative_ingredients_from_string(ingredients_string)
  #   tentative_ingredients = []
  #   ingredients_string.strip!
  #   ingredients_string.downcase!
  #   ingredients_string.gsub!("\n", " ")
  #   ingredients_string.gsub!("  ", " ")
  #   ingredients_string.gsub!(/[†‡*\(\)\[\]{}]/, '')
  #   ingredients_string.gsub!(/contains \d% or less of[ :]/, '')
  #   ingredients_string.gsub!(/contains \d% or less(:|( -))/, '')
  #   ingredients_string.gsub!(/contains less than \d% ?(of)?:? ?/, '')
  #   ingredients_string.gsub!(/(and )?less than \d%( of( the following:? |: )?|:)?/, '')
  #   ingredients_string.gsub!(/\d% or less of (the following:? )?/, '')
  #   ingredients_string.gsub!(/contains \w+ percent or less of:?/, '')
  #   ingredients_string.gsub!(/(\d{1,3}\.)?\d{1,3}\s?%/, '')
  #   on_and_after_index = ingredients_string.index('ingredients:')
  #   ingredients_string = ingredients_string.slice(on_and_after_index, ingredients_string.length + 1) if on_and_after_index
  #   ingredients_string.gsub!('ingredients:', '')
  #   ingredients_string.chop! if ingredients_string.end_with?('.')
  #   ingredients_string.strip!

  #   ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
  #   ingredients_string.split('').each do |c|
  #     if open_paren == close_paren && open_square == close_square && open_curly == close_curly && (c == ',' || c == '.' || c == ';')
  #       if ingredient.size > 0
  #         tentative_ingredients << build_ingredient_from_string(ingredient)
  #       end

  #       ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
  #       next
  #     end
  #     open_paren += 1 if c == '('
  #     close_paren += 1 if c == ')'
  #     open_square += 1 if c == '['
  #     close_square += 1 if c == ']'
  #     open_curly += 1 if c == '{'
  #     close_curly += 1 if c == '}'
  #     ingredient += c
  #   end

  #   tentative_ingredients << build_ingredient_from_string(ingredient) if ingredient.length > 0

  #   return tentative_ingredients
  # end

  # private
  #   def self.get_amount_from_string(nutrition_facts_string, start_index, unit)
  #     nutrition_facts_string.slice(start_index, nutrition_facts_string.length + 1).match(/^\s*<?(\d+(.\d+)?)#{unit}/)&.captures&.first&.to_f
  #   end

  #   def self.build_ingredient_from_string(ingredient_string)
  #     # cleanup string
  #     ingredient_string.strip!
  #     ingredient_string.gsub!(/(\w* )*((each of )|contains one or more of )?the following:? /, '')
  #     ingredient_string.gsub!(/^and(\/or)? /, '')
  #     ingredient_string.chop! while ingredient_string.end_with?('.')
  #     ingredient_string.sub!('.', '') while ingredient_string.start_with?('*')
  #     ingredient_string.strip!

  #     # split up the name and composition based on first (, {, or [
  #     split_index = [ingredient_string.index('('), ingredient_string.index('{'), ingredient_string.index('[')].compact.min
  #     ingredient_name = split_index ? ingredient_string.slice(0, split_index) : ingredient_string
  #     ingredient_composition = split_index ? ingredient_string.slice(split_index, ingredient_string.length + 1) : ''

  #     return Ingredient.new(
  #       name: ingredient_name.strip,
  #       composition: ingredient_composition.strip
  #     )
  #   end
end
