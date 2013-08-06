class ApplicationController < ActionController::Base
	extend DynamicResources

  protect_from_forgery
end
