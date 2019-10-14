class NutrientsController < ApplicationController
  before_action :set_nutrient, only: [:show, :edit, :update, :destroy]
  before_action :set_nutrients, only: [:index]

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @nutrient.update_attributes(nutrient_params)
      flash[:success] = I18n.t('nutrients.update.success')
      redirect_to nutrient_path(@nutrient)
    else
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

    def set_nutrients
      @nutrients = Nutrient.all.alphabetical.search(params[:search])
      @num_records = @nutrients.count
    end

    def nutrient_params
      params.require(:nutrient).permit(:name, :description, :source, :unit, :is_limiting)
    end
end
