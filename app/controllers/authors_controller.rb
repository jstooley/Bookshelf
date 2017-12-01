class AuthorsController < ApplicationController

  get '/authors' do
      erb :'authors/index'
  end


  get '/authors/:id' do
    @author = Author.find_by(id: params['id'])
    if logged_in?
      @user = User.find_by(id: session['user_id'])
      erb :'authors/show'
    else
      erb :'authors/show'
    end
  end

end
