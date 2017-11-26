class GenresController < ApplicationController

  get 'genres/list' do
    erb :'genres/show'
  end

  get 'genres/:id' do
    
    @genre = Genre.find_by(id: params[:id])

    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :'genres/show_books'
    else
      erb :'genres/show_books'
    end

end
