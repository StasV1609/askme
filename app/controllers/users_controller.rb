class UsersController < ApplicationController
  def index
    @users = User.new(id: 1, name: 'Stas', username: 'Stas1609'), User.new(id: 2, name: 'Artem', username: 'Art12')
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
  end

  def show
    @user = User.new(
      name: 'Stas',
      username: 'Stas1609',
    )

    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('27.03.2016')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('27.03.2016')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('22.04.2016'))
    ]

    @questions_amount = @questions.count
    @new_question = Question.new
  end

  private
    def user_params
      params.require(:user).permit(:name, :username, :email, :password,
                                   :password_confirmation, :avatar_url)
    end
end
