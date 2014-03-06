module PortfolioHelper
  def portfolio_link_to_project(project, options = {})
    link_to project.portfolio_name, project.homepage.presence || '#', options
  end

  def link_to_modal(project, &block)
    link_to '#', :class => 'info', :data => { 
      :image => project.portfolio_image, 
      :description => textilizable(project.short_description, :project => project).to_str, 
      :title => portfolio_link_to_project(project, :class => 'homepage').to_str
    }, &block
  end
end
