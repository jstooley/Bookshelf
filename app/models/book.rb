class Book < ActiveRecord::Base
  belongs_to :author
  has_many :user_books
  has_many :books through: :user_books
end
