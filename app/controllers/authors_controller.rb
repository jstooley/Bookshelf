class AuthorsController < ApplicationController

  get '/authors/list' do
    if logged_in?
      @user = User.find_by(id: session['user_id'])
      erb :'authors/show'
    else
      erb :'authors/show'
    end
  end

end
