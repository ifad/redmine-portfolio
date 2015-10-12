class PortfolioController < ApplicationController
  unloadable

  layout 'portfolio'

  PRIVATE_ACCESS = [
    :user_setup,
    :check_if_login_required,
    :check_password_change
  ]

  helper :all

  def index
    @projects = Project.portfolio
  end

end
