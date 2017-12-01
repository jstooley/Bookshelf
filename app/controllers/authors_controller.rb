class AuthorsController < ApplicationController

  get '/authors' do
      @authors = Author.all
      erb :'authors/index'
  end


  get '/authors/:id' do
    @author = Author.find_by(id: params[:id])
    erb :'authors/show'
  end
  
end
