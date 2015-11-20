class IncomingController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    puts params
    puts "hello there"
    puts params[:sender]
    users = User.where(email: params[:sender])
    @user = users.first ? users.first : nil #Find the user by using params[:sender]
    puts @user
    if @user.nil? || @user.pending_invite?
      User.invite!(email: params[:sender], name: params[:sender])
    else
      puts params[:subject]
      @topic = Topic.find_or_create_by(title: params[:subject])
      puts @topic
      @url = params["stripped-text"]
      puts @url
      @bookmark = Bookmark.new(user: @user, topic: @topic, url: @url)
      puts @bookmark
      authorize @bookmark
      @bookmark.save
    end
    head 200
  end

end
