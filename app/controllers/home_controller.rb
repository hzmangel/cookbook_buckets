# Home controller for main page
class HomeController < ApplicationController
  def index
  end

  def upload_token
    put_policy = Qiniu::Auth::PutPolicy.new(
      QINIU_CONFIG[:bucketName]
    )
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    render json: {token: uptoken}
  end
end
