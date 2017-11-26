class BooksController < ApplicationController

  get '/books/new' do
    if logged_in?
      erb :'books/new'
    else
      redirect to '/login'
    end
  end

  post '/books/new' do

    @book = Book.create(title: params['title'], year_published: params['year_published'])
    @genre = Genre.find_or_create_by(name: params['genre'])
    @author = Author.find_or_create_by(name: params['author'])
    @book.author = @author
    @book.genre = @genre
    @book.save
    @author.new_book
    redirect to '/show'
  end


end
