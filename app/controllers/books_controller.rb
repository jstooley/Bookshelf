class BooksController < ApplicationController

  get '/books/new' do
    authenticate_user!
    erb :'books/new'
  end

  get '/books' do
    @books = Book.all
    erb :'books/index'
  end

  get '/books/:id/edit' do
    authenticate_user!
    @book = Book.find_by(id: params['id'])
    erb :'books/edit'
  end

  post '/books/new' do
    authenticate_user!
    @book = Book.create(title: params['title'], year_published: params['year_published'])
    @genre = Genre.find_or_create_by(name: params['genre'])
    @author = Author.find_or_create_by(name: params['author'])
    @book.author = @author
    @book.genre = @genre
    @book.original_poster = current_user.id
    @book.save
    @author.new_book #ups author book count
    UserBook.find_or_create_by(user_id: current_user.id,book_id: @book.id)
    redirect to '/show'
  end

  post '/books/:id/add' do
    authenticate_user!
    @book = Book.find_by(id: params[:id])
    UserBook.find_or_create_by(user_id: current_user.id, book_id: params[:id])
    redirect to '/show'
  end

  put '/books/:id/edit' do
    authenticate_user!
    @book = Book.find_by(id: params['id'])
    @book.title = params['title']
    @book.year_published = params['year_published']
    @author_org = @book.author
    @author_new = Author.find_or_create_by(name: params['author'])

    @book.author_edit(@author_org,@author_new) #checks/sets if author is changed then saves

    @genre_org = @book.genre
    @genre_new = Genre.find_or_create_by(name: params['genre'])

    @book.genre_edit(@genre_org,@genre_new)#checks/sets if genre is changed then saves

    redirect to '/show'
  end

  delete '/books/:id/remove' do
    authenticate_user!
    UserBook.find_by(book_id: params[:id],user_id: current_user.id).delete # if not op just take off list
    redirect to '/show'
  end

  delete '/books/:id' do
    authenticate_user!
    @book = Book.find_by(id: params[:id])
    if @book && @book.original_poster == current_user.id
      @book.destroy_with_relationships
    end
    redirect to '/books'
  end
end
