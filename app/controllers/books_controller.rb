class BooksController < ApplicationController

  get '/books/new' do
    if logged_in?
      erb :'books/new'
    else
      redirect to '/login'
    end
  end

  get '/books' do
      @user = User.find_by(id: session['user_id'])
      @books = Book.all
      erb :'books/index'
  end

  get '/books/remove' do
    if logged_in?
        @user = User.find_by(id: session['user_id'])
      erb :'books/remove_book'
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
    @book.original_poster = current_user.id
    @book.save
    @author.new_book
    UserBook.find_or_create_by(user_id: session['user_id'],book_id: @book.id)
    redirect to '/show'
  end

  post '/books/:id/add' do
    @book = Book.find_by(id: params['id'])
    UserBook.find_or_create_by(user_id: session['user_id'], book_id: params['id'])
    redirect to '/show'
  end

  put '/books/:id/edit' do
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
  end

  delete '/books/:id/remove' do
  end

  delete '/books/:id' do

    @user_books = UserBook.find_by(id: params['id'])
    @book = Book.find_by(id: @user_books.book_id)
    if @book.original_poster == session['user_id'] # is deleter the op?

      @genre_count = 0# to see how many books have this genre

      UserBook.all.each do |user_book| #if is op delete book of all list
        if user_book.book_id == @book.id
          user_book.delete
        end
    end

      Book.all.each do |book| # counts how many books have the genre of soon to be deleted book
        if book.genre_id == @book.genre_id
          @genre_count += 1
        end
      end
      if @genre_count == 1
        Genre.find_by(id: @book.genre_id).delete #delete genre if this book is the obnly one with it
      end

      @author = Author.find_by(id: @book.author_id)
      @author.published_work -= 1
      if @author.published_work == 0 # authors only book?
        @author.delete # if so delete
      end

      @book.delete # delete the book op is removing
    else
      @user_books.delete # if not op just take off list
    end
    redirect to '/show'
  end
end

# Todos

# 1. check for an authenticated user on all routes that reuqire an authenticated user not just 'GET' routes
# 2. Add the DELETE /books/:id/remove route with logic to remove a book from a user's book collection
# 3. Clean up the DELETE /books/:id route to only handle deletion for verified user
# 4. Implement the option to Add or Remove books (and delete edit for original posters) for your collection from the author books and genre books index pages
# 5. User the current_user instance method for your controllers and views.
# 6. Make a pull request with the changes on a seperate github branch and @lukeghenco when submitting pull request. Do not merge into master branch until review is completed by Luke
