class AuthorsController < ApplicationController

  get '/authors/list' do
      erb :'authors/show'
  end

  get '/authors/:id/show' do
    @author = Author.find_by(id: params['id'])
    if logged_in?
      @user = User.find_by(id: session['user_id'])
      erb :'authors/show_books'
    else
      erb :'authors/show_books'
    end
  end

end
