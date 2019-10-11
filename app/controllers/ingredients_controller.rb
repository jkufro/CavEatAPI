class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

  def index
    @ingredients = Ingredient.all
  end

  def show
  end

  def edit
  end

  def update
    if @ingredient.update_attributes(ingredient_params)
      flash[:notice] = I18n.t('ingredients.update.success')
      redirect_to ingredient_path(@ingredient)
    else
      # return to the 'new' form
      flash[:error] = I18n.t('ingredients.update.failure')
      render action: 'edit'
    end
  end

  def destroy
    @ingredient.destroy
    flash[:notice] = I18n.t('ingredients.destroy.success')
    redirect_to :ingredients
  end

  private
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    def ingredient_params
      params.require(:ingredient).permit(:upc, :name)
    end
end