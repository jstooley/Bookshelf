class UserBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  def self.delete_all(book)
    self.all.each do |user_book| #delete book off all list
      if user_book.book_id == book.id
        user_book.delete
      end
    end
  end
  
end
