class Book < ActiveRecord::Base
  # rails g migration add_user_id_to_books user_id:integer
  belongs_to :user
  resourcify
end
