class Post < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "120x120>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
  belongs_to :user
  has_many :likes, as: :likeable
  has_many :comments, dependent: :destroy
  
end
