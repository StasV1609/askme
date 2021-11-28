class UsersController < ApplicationController
  def index
    @users = User.new(id: 1, name: 'Stas', username: 'Stas1609'), User.new(id: 2, name: 'Artem', username: 'Art12', avatar_url: 'https://images.app.goo.gl/yDtEE4iZQgv3F5U26' )
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Stas',
      username: 'Stas1609',
    )
    
    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('27.03.2016')),
      Question.new(
        text: 'В чем смысл жизни?', created_at: Date.parse('27.03.2016')
      )
    ]

    @new_question = Question.new
  end
end
