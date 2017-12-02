class GenresController < ApplicationController

  get '/genres' do
    @genre = Genre.all
    erb :'genres/index'
  end

  get '/genres/:id' do
      @genre = Genre.find_by(id: params['id'])
      erb :'genres/show'
  end

end
