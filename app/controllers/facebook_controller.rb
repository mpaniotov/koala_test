class FacebookController < ApplicationController
  before_filter :authenticate_user!

  def index
    unless current_user.facebook_oauth_setting
      @oauth = Koala::Facebook::OAuth.new(*******, '**************', 'http://localhost:3000/callback/')
      p '+'*25
      #p  @oauth.get_access_token(params[:code])

      session["oauth_obj"] = @oauth
      redirect_to @oauth.url_for_oauth_code
    else
      redirect_to "/facebook_profile"
    end
  end

  def callback
    unless current_user.facebook_oauth_setting
      @oauth = session["oauth_obj"]
      p '*'*25
      p params[:code].split(", ")
      #FacebookOauthSetting.create({:access_token =>"******************", :user_id => current_user.id})
      redirect_to "/facebook_profile"
    else
      redirect_to "/"
    end
  end

  def facebook_profile
    if current_user.facebook_oauth_setting
      @graph = Koala::Facebook::API.new('*********')
      p '-'*25
      p current_user.facebook_oauth_setting.access_token
      #@graph.put_wall_post("hi!!!")
      @graph.put_picture('public/img/1.png', {:message => "an image of mine!"})
      @graph.put_wall_post('test: putt picture on the wall',{"picture" => "http://www.dasonlightinginc.com/uploads/2/9/4/2/2942625/4781952_orig.jpg"})
      @profile = @graph.get_object("me")
      @picture = @graph.get_picture("me")
      @feed = @graph.get_connections("me","feed")
      @friends = @graph.get_connections("me", "friends")
    else
      redirect_to "/"
    end
  end
end
