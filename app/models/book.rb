class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :genre
  has_many :user_books
  has_many :users, through: :user_books

  def author_edit(author_org,author_new)
    unless author_org == author_new #check to see if changed arthor
      author_org.published_work -= 1
      author_org.save
      author_new.new_book
      self.author = author_new
      if author_org.published_work == 0 #delete author if no longer has book
        author_org.delete
      end
      self.save
    end
  end

  def genre_edit(genre_org,genre_new)
    unless genre_org == genre_new #check if genre changed
      self.genre = genre_new
      self.save
      if !Book.find_by(genre_id: genre_org.id) #checks books to see if any have old genre if not deltes them
        genre_org.delete
      end
    end
  end

  def destroy_with_relationships
    self.user_books.destroy_all
    self.destroy
    @user_book = UserBook.find_by(book_id: params[:id],user_id: current_user.id)
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
  end

end
