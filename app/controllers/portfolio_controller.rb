class PortfolioController < ApplicationController
  unloadable

  layout 'portfolio'

  if Portfolio::Redmine.public_access?
    skip_before_filter :user_setup, :check_if_login_required, :check_password_change, :only => :index
  end

  def index
    @projects = Project.portfolio
  end
end
