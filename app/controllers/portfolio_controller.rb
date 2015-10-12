class PortfolioController < ApplicationController
  unloadable

  layout 'portfolio'

  helper :all

  def index
    @projects = Project.portfolio
  end

end:q
