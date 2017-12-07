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
    self.author.published_work = self.author.books.count - 1
    self.destroy
    self.author.save
  end

end
