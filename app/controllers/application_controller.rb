class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user

  def render_404
    # # DPR: supposedly this will actually render a 404 page in production
    # raise ActionController::RoutingError.new('Not Found')
    # Above code does not seem to pass test?

    render file: "#{Rails.root}/public/404.html" , status: :not_found
  end

private
  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    else
      #if not a registered user, redirect to homepage
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in"
      redirect_to root_path
    end
  end
end
