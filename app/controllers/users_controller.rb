class UsersController < ApplicationController

  get '/login' do
    erb :'users/login'
  end

  get '/signup' do
    erb :'users/signup'
  end

  post 'login' do

    if logged_in?
      redirect to ''
    else
      erb :'users/login'
    end

  end

  post 'signup' do

    if logged_in?
      redirect to ""
    else
      erb :'users/signup'
    end

  end

end
