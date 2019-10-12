class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]
  before_action :set_ingredients, only: [:index, :bulk_update]

  def index
    @ingredients = @ingredients.paginate(page: params[:page], per_page: 100)
  end

  def bulk_update
    failed_updates = BulkUpdateService.bulk_update(@ingredients, bulk_update_params)
    succeeded_updates = @num_records - failed_updates
    if failed_updates == 0
      flash[:success] = I18n.t('ingredients.bulk_update.success', succeeded: succeeded_updates)
    else
      flash[:warning] = I18n.t('ingredients.bulk_update.warning', succeeded: succeeded_updates, failed: failed_updates)
    end
    redirect_to ingredients_path(search: params[:search])
  end

  def show
  end

  def edit
  end

  def update
    if @ingredient.update_attributes(ingredient_params)
      flash[:success] = I18n.t('ingredients.update.success')
      redirect_to ingredient_path(@ingredient)
    else
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

    def set_ingredients
      @ingredients = Ingredient.all.search(params[:search])
      @num_records = @ingredients.count
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :composition, :description, :is_warning)
    end

    def bulk_update_params
      params.require(:ingredient).permit(:description, :is_warning)
    end
end
