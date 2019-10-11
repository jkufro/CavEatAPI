class NutrientsController < ApplicationController
  before_action :set_nutrient, only: [:show, :edit, :update, :destroy]

  def index
    @nutrients = Nutrient.all
  end

  def show
  end

  def edit
  end

  def update
    if @nutrient.update_attributes(nutrient_params)
      flash[:notice] = I18n.t('nutrients.update.success')
      redirect_to nutrient_path(@nutrient)
    else
      # return to the 'new' form
      flash[:error] = I18n.t('nutrients.update.failure')
      render action: 'edit'
    end
  end

  def destroy
    @nutrient.destroy
    flash[:notice] = I18n.t('nutrients.destroy.success')
    redirect_to :nutrients
  end

  private
    def set_nutrient
      @nutrient = Nutrient.find(params[:id])
    end

    def nutrient_params
      params.require(:nutrient).permit(:upc, :name)
    end
end