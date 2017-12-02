class GenresController < ApplicationController

  get '/genres' do
    @genre = Genre.all
    erb :'genres/index'
  end

  get '/genres/:id' do
    if logged_in?
      @genre = Genre.find_by(id: params['id'])
      erb :'genres/show'
    else
      redirect to '/login'
    end
  end

end
