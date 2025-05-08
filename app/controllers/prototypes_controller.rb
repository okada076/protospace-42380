class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end
  
  def new
    @prototype = Prototype.new
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user) 
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
   if @prototype.update(prototype_params)
    redirect_to @prototype, notice: 'プロトタイプが更新されました。'
   else
    flash.now[:alert] = '更新に失敗しました。'
    render :edit
   end
 end

 def destroy
  @prototype = Prototype.find(params[:id])
  @prototype.destroy
  redirect_to root_path
 end

  def create
      @prototype = Prototype.new(prototype_params)
      if @prototype.save
        redirect_to root_path  # 投稿成功時はトップページへ
      else
        render :new, status: :unprocessable_entity  # 投稿失敗時はフォームに戻す
      end
    end

    def set_prototype
      @prototype = Prototype.find(params[:id])
    end

   private
   def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
   end

   def move_to_index
    unless user_signed_in? && current_user == @prototype.user
      redirect_to root_path
    end
   end
  end
