class HomeController < ApplicationController
   before_filter :require_user, :except => [:create]
  def index
  end

end
