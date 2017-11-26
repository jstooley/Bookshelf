class Author < ActiveRecord::Base
  has_many :books
  has_many :genres, through: :books

  def new_book
    if self.published_work
      self.published_work +=1
    else
      self.published_work = 1
    end
    self.save
  end
end
