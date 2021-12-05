class UsersController < ApplicationController

  before_action :set_user, only: %i[edit update show]
  before_action :authorize_user, except: %i[create new show index]

  def index
    @users = User.all
  end

  def new
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?
    @user = User.new
  end

  def edit
  end

  def create
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?

    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, notice: 'Пользователь успешно зарегестрирован'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Данные обновлены'
    else
      render :edit
    end
  end

  def show
    @uestions = @user.questions.order(created_at: :desc)

    @new_question = @user.questions.build

    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('27.03.2016')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('27.03.2016')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('22.04.2016'))
    ]

    @questions_amount = @questions.count
    @answers_amount = @questions.count(&:answer)
    @unanswered_amount = @questions_amount - @answers_amount

    @new_question = Question.new
  end

  private
    def authorize_user
      reject_user unless @user == current_user  
    end

    def set_user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :username, :email, :password,
                                   :password_confirmation, :avatar_url)
    end
end
