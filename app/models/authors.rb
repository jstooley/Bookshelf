class Author < ActiveRecord::Base
  has_many :books
  has_many :genres, through: :books

  def new_book
    
    if self.year_published
      self.year_published +=1
    else
      self.year_published = 1
    end
end
