class AuthorsController < ApplicationController

  get '/authors' do
      @authors = Author.all
      erb :'authors/index'
  end


  get '/authors/:id' do
    @authors = Author.all
    erb :'authors/show'
  end
end
