class BooksController < ApplicationController

  get '/books/new' do
    if logged_in?
      erb :'books/new'
    else
      redirect to '/login'
    end
  end

  get '/books' do
      @books = Book.all
      erb :'books/index'
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
    if logged_in?
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
    else
      redirect to '/login'
    end
  end

  post '/books/:id/add' do
    if logged_in?
      @book = Book.find_by(id: params[:id])
      UserBook.find_or_create_by(user_id: current_user.id, book_id: params[:id])
      redirect to '/show'
    else
      redirect to '/login'
    end
  end

  put '/books/:id/edit' do
    if logged_in?
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
    else
      redirect to '/login'
    end
  end

  delete '/books/:id/remove' do
    if logged_in?
      UserBook.find_by(book_id: params[:id],user_id: current_user.id).delete # if not op just take off list
      redirect to '/show'
    else
      redirect to '/login'
    end
  end

  delete '/books/:id' do
    if logged_in?
      @user_books = UserBook.find_by(book_id: params[:id],user_id: current_user.id)
      @book = Book.find_by(id: @user_books.book_id)
      @genre_count = 0# to see how many books have this genre

      UserBook.delete_all(@book) #delete book off all lists

      @genre_id = @book.genre.id #to have genre_id after book is deleted
      @author_id = @book.author.id #to have genre_id after book is deleted
      @book.delete # delete the book op is removing

      if !Book.all.include?(@genre_id)  # counts how many books have the genre of soon to be deleted book
        Genre.find_by(id: @genre_id).delete #delete genre if the deleted book is the obnly one with it
      end

        @author = Author.find_by(id: @author_id)
        @author.published_work -= 1
        if @author.published_work == 0 # authors only book?
          @author.delete # if so delete
        end
        redirect to '/show'
      else
        redirect to '/login'
      end
  end
end

# Todos




# 6. Make a pull request with the changes on a seperate github branch and @lukeghenco when submitting pull request. Do not merge into master branch until review is completed by Luke
