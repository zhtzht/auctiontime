class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 protect_from_forgery with: :exception
 include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, :with => :show_error
  rescue_from ActionView::MissingTemplate,:with => :show_error
  rescue_from ActionView::Template::Error,:with => :show_error
  rescue_from ActionController::RoutingError, :with => :show_error
  rescue_from ActionController::UnknownController, :with => :show_error  
 
  def show_error
    redirect_to action: 'error', controller: 'staticpages'
  end
end
