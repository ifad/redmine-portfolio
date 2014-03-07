module PortfolioHelper
  def portfolio_link_to_project(project, options = {})
    link_to project.portfolio_name, project.homepage.presence || '#', options
  end

  def portfolio_link_to_modal(project, &block)
    link_to '#', :class => 'info', :data => { 
      :image => project.portfolio_image, 
      :description => textilizable(project.short_description, :project => project).to_str, 
      :title => portfolio_link_to_project(project, :class => 'homepage').to_str
    }, &block
  end

  def portfolio_image_for(project)
    src = if project.portfolio_image =~ /\/attachments\/download\/(\d+)\/.+\.(\w+)$/i
      "data:image/#{$2};base64," + Base64.encode64(File.read(Attachment.find($1).diskfile))
    else
      project.portfolio_image
    end

    image_tag(src, :title => project.portfolio_name)
  end
end
