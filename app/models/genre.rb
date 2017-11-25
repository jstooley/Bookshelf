class Genre < ActiveRecord::Base
  has_many :books
  has_many :authors, thorugh: :books
end
