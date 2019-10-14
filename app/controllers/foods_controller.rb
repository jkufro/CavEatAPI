class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  before_action :set_foods, only: [:index]

  def index
    @foods = @foods.paginate(page: params[:page], per_page: 100)
  end

  def show
  end

  def edit
  end

  def update
    if @food.update_attributes(food_params)
      flash[:success] = I18n.t('foods.update.success')
      redirect_to food_path(@food)
    else
      flash[:error] = I18n.t('foods.update.failure')
      render action: 'edit'
    end
  end

  def destroy
    @food.destroy
    flash[:notice] = I18n.t('foods.destroy.success')
    redirect_to :foods
  end

  private
    def set_food
      # @food = Food.eager_load([{ nutrition_facts: :nutrient }, :ingredients]).find(params[:id])
      @food = Food.includes([:ingredients, nutrition_facts: :nutrient]).find(params[:id])
      # @food = Food.joins([:ingredients, nutrition_facts: :nutrient]).find(params[:id])
      # @food = Food.preload([:ingredients, nutrition_facts: :nutrient]).find(params[:id])
    end

    def set_foods
      @foods = Food.all.search(params[:search])
      @num_records = @foods.count
    end

    def food_params
      params.require(:food).permit(:upc, :name)
    end
end
