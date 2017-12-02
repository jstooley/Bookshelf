
class UsersController < ApplicationController

  get '/login' do

    if logged_in?
      redirect to '/show'
    else
      erb :'users/login'
    end

  end

  get '/signup' do

    if logged_in?
      redirect to "/show"
    else
      erb :'users/signup'
    end

  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/'
    else
      redirect to '/login'
    end
  end

  get '/show' do
    if logged_in?
      @user = User.find_by(id: current_user)
      @books = Book.all
      @user_books = GenreBook.all
      erb:'users/show'
    else
      redirect to '/login'
    end
  end

  post '/login' do

    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/show'
    else
      @error = true
      erb :"users/login"
    end

  end

  post '/signup' do
    if User.find_by(username: params[:username]) #check is usernmae is in use
      @username_error = true
    end
    if User.find_by(email: params[:email]) #checl if email is in use
      @email_error = true
    end

    if @email_error || @username_error
      erb :'users/signup'
    else
      @user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
      @user.save
      if @user.save
        session[:user_id] = @user.id
        redirect to "/show"
      else
        @save_error = true
        erb :"users/signup"
      end
    end

  end

end
