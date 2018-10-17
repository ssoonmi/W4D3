class CatsController < ApplicationController
  before_action :ensure_logged_in, only: [:edit, :update, :new, :create]
  before_action :ensure_owner_of_cat, only: [:edit, :update]

  def ensure_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def ensure_owner_of_cat
    cat = current_user.cats.where(id: params[:id])
    redirect_to cats_url unless cat
  end

  def owner_of_cat?
    return false unless current_user
    !current_user.cats.where(id: params[:id]).empty?

  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @owner = owner_of_cat?
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
