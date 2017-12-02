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
    end
  end

end
