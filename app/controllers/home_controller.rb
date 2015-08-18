class HomeController < ApplicationController
  before_action :authenticate_user!

  def home
    @user = current_user
    @feeds = current_user.related_posts.order("created_at desc")
  end

end
