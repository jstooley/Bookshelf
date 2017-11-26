class User < ActiveRecord::Base
  validates_presence_of :username, :email
  has_secure_password
  has_many :user_books
  has_many :books, through: :user_books

  def slug
    slug = self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def self.find_by_slug(slug)
    sluged_user = ""

    self.all.each do |user|
      if user.slug == slug
         sluged_user = user
      end

    end
      sluged_user
  end
end
