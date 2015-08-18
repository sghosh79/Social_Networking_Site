class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :friendships
  has_many :friends, -> { where 'friendships.status in (0, 1)'}, :through => :friendships

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :messages, foreign_key: "from"

  scope :suggested_friends, -> (current_user){ where("id not in (?)",  (current_user.friends.map(&:id) << current_user.id <<  current_user.inverse_friendships.pending_requests.map(&:user_id)).flatten) }

  has_attached_file :profile_pic, :styles => { :medium => "300x300>", :thumb => "120x120>" }, :default_url => "missing.jpg"
  validates_attachment_content_type :profile_pic, :content_type => /\Aimage\/.*\Z/
  #validates_attachment :profile_pic, :presence => true,
  #:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
  #:size => { :in => 0..1000.kilobytes }


  def full_name
    [self.first_name, self.last_name].join(" ").titlecase
  end

  def my_pending_friend_requests
    inverse_friendships.pending_requests
  end

  def is_like?(feed)
    likes.map(&:likeable_id).include? feed.id
  end

  def my_friends
    friendships.accepted_requests.map(&:friend)
  end

  def related_posts
    ids = []
    ids << my_friends.map(&:id) << self.id
    Post.where("user_id in (?)", ids.flatten)
  end

  def profile_posts
    posts = (Post.where("receiver_id=?", self.id) + self.posts)
    posts.sort{|a,b| b.created_at <=> a.created_at}
  end

  def today_chat_history(friend_id)
    sent_by_me = self.messages.where(to: friend_id)
    friend = User.find(friend_id)
    sent_by_friend = friend.messages.where(to: self.id)
    history = sent_by_me + sent_by_friend
    history.sort{|a,b| a.created_at <=> b.created_at}
  end

end
