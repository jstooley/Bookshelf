class User < ActiveRecord::Base
  validates_presence_of :username, :email
  has_secure_password
  has_many :user_books
  has_many :books, through: :user_books


end
