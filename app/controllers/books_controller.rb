class BooksController < ApplicationController

  get '/books/new' do
    if logged_in?
      erb :'books/new'
    else
      redirect to '/login'
    end
  end

  get '/books/edit' do
    if logged_in?
      @user = User.find_by(id: session['user_id'])
      erb :'books/choose_edit'
    else
      redirect to '/login'
    end
  end

  get '/books/:id/edit' do

    if logged_in?
      @book = Book.find_by(id: params['id'])
      erb :'books/edit'
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
    UserBook.find_or_create_by(user_id: session['user_id'],book_id: @book.id)
    redirect to '/show'
  end

  post '/books/:id/edit' do
    @book = Book.find_by(id: params['id'])
    binding.pry
    redirect to '/show'
  end


end
