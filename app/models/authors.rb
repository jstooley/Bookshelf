class Author < ActiveRecord::Base
  has_many :books
  has_many :genres, through: :books

  def new_book # sets a aithors number of published works
    self.published_work = self.books.count
    self.save
  end


end
