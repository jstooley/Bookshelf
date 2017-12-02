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
      @author.new_book
      UserBook.find_or_create_by(user_id: session['user_id'],book_id: @book.id)
      redirect to '/show'
    else
      redirect to '/login'
    end
  end

  post '/books/:id/add' do
    if logged_in?
      @book = Book.find_by(id: params['id'])
      UserBook.find_or_create_by(user_id: current_user, book_id: params['id'])
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
      @arthor_org = Author.find_by(id: @book.author_id)
      @arthor_new = Author.find_or_create_by(name: params['author'])
      unless @arthor_org == @arthor_new #check to see if changed arthor
        @arthor_org.published_work -= 1
        @arthor_org.save
        @arthor_new.new_book
        @book.author = @arthor_new
        if @arthor_org.published_work == 0 #delete author if no longer has book
          @arthir_org.delete
        end
      end
      @genre_org = Genre.find_by(id: @book.genre_id)
      @genre_new = Genre.find_or_create_by(name: params['genre'])
      unless @genre_org == @genre_new #check if genre changed
        @book.genre = @genre_new
      end
      @book.save
      if Book.find_by(genre_id: @genre_org.id) == nil #checks books to see if any have old genre if not deltes them
        @genre_org.delete
      end
      redirect to '/show'
    else
      redirect to '/login'
    end
  end

  delete '/books/:id/remove' do
    if logged_in?
      UserBook.find_by(id: params[:id]).delete # if not op just take off list
    else
      redirect to '/login'
    end
  end

  delete '/books/:id' do
    if logged_in?
      @user_books = UserBook.find_by(id: params[:id])
      @book = Book.find_by(id: @user_books.book_id)
      @genre_count = 0# to see how many books have this genre

      UserBook.all.each do |user_book| #delete book off all list
        if user_book.book_id == @book.id
          user_book.delete
        end
      end

      @genre_id = @book.genre.id #to have genre_id after book is deleted
      @author_id = @book.author.id #to have genre_id after book is deleted
      @book.delete # delete the book op is removing

      if Book.all.include?(@genre_id)  # counts how many books have the genre of soon to be deleted book
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

# 1. check for an authenticated user on all routes that reuqire an authenticated user not just 'GET' routes
# 2. Add the DELETE /books/:id/remove route with logic to remove a book from a user's book collection
# 3. Clean up the DELETE /books/:id route to only handle deletion for verified user
# 4. Implement the option to Add or Remove books (and delete edit for original posters) for your collection from the author books and genre books index pages
# 5. User the current_user instance method for your controllers and views.
# 6. Make a pull request with the changes on a seperate github branch and @lukeghenco when submitting pull request. Do not merge into master branch until review is completed by Luke
