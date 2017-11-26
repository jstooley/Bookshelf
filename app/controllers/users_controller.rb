
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
      session.clear
      redirect to '/'
  end

  get '/show' do
    if logged_in?
      @user = User.find_by(id: session[:user_id])
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
      redirect to "/login"
    end

  end

  post '/signup' do

    @user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
    @user.save

    if @user.save

      session[:user_id] = @user.id
      redirect to "/show"
    else
      redirect to "/signup"
    end

  end

end
