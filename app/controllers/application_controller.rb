class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :render_500

  private

  def render_500(exception)
    render template: 'shared/500.html', status: 500
  end

end
