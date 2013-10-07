class ApplicationController < ActionController::Base
  #protects against Cross-site Request Forgery(CSRF) attacks
  protect_from_forgery

  # track users status
  include SessionsHelper
end
