class UsersController < ApplicationController
  def index
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Stas',
      username: 'Stas1609',
      avatar_url: 'https://image.freepik.com/free-vector/person-avatar-design_24877-38137.jpg'
    )
  end
end
