class PortfolioController < ApplicationController
  unloadable

  layout 'portfolio'

  PRIVATE_ACCESS = [
    :user_setup,
    :check_if_login_required,
    :check_password_change
  ]

  skip_before_filter *PRIVATE_ACCESS, :only => :index
  before_filter :public_access?, :only => :index

  helper :all

  def index
    @projects = Project.portfolio
  end

  protected
    def public_access?
      PRIVATE_ACCESS.map{ |v| send(v) }.all? unless Portfolio::Redmine.public_access?
    end

end
