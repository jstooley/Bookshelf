class GenresController < ApplicationController

  get 'genres/list' do
    erb :'genres/show'
  end
end
