class PortfolioController < ApplicationController
  unloadable

  layout 'portfolio'

  def index
    @projects = Project.where(id: Portfolio::Redmine.presence_attribute.custom_values.where(value: '1').select(:customized_id)).order(:name)
  end
end
