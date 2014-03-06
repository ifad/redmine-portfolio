class PortfolioController < ApplicationController
  unloadable

  layout 'portfolio'

  def index
    @projects = Project.portfolio
  end
end
