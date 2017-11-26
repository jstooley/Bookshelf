class BooksController < ApplicationController

  get '/books/new' do
    erb :'books/new'
  end

  post '/books/new' do
    binding.pry
    redirect to '/show'
  end


end
