class Post < ActiveRecord::Base
  attr_accessible :age, :name
  validates_presence_of :age, :name
end
