require 'test_helper'

class ApiV1FoodsControllerTest < ActionDispatch::IntegrationTest
  should 'post by upc' do
    post api_v1_upc_path, params: { upc: foods(:food_one).upc }
    assert_response :success
  end

  should 'fail to post by upc' do
    post api_v1_upc_path
    assert_response :not_found

    post api_v1_upc_path, params: { upc: nil }
    assert_response :not_found

    post api_v1_upc_path, params: { upc: 'This is not a upc' }
    assert_response :not_found
  end

  should 'post by strings' do
    post api_v1_strings_path, params: {
      upc: 1234444,
      nutrition_facts: '',
      ingredients: ""
    }
    assert_response :success

    post api_v1_strings_path, params: {
      upc: 1234444,
      nutrition_facts: '',
      ingredients: "Ingredient One (Description For Ingredient One.)"
    }
    assert_response :success
  end

  should 'fail to post by strings' do
    post api_v1_strings_path
    assert_response :not_found

    post api_v1_strings_path, params: { upc: nil, nutrition_facts: nil, ingredients: nil }
    assert_response :not_found
  end
end
