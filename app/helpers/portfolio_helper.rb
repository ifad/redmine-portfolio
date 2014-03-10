module PortfolioHelper
  def portfolio_link_to_project(project, options = {}, &block)
    options[:target] = :blank

    if block_given?
      link_to project.homepage.presence || '#', options, &block
    else
      link_to project.portfolio_name, project.homepage.presence || '#', options
    end
  end

  def portfolio_link_to_modal(project, options = {}, &block)
    options[:class] = "#{options[:class]} info"
    (options[:data] ||= {}).merge!({
      :image => portfolio_image_for(project).to_str,
      :url => project.homepage,
      :description => textilizable(project.short_description, :project => project).to_str,
      :title => portfolio_link_to_project(project, :class => 'homepage').to_str
    })

    link_to '#', options, &block
  end

  def portfolio_image_src_for(project)
    if project.portfolio_image =~ /\/attachments\/download\/(\d+)\/.+\.(\w+)$/i
      "data:image/#{$2};base64," + Base64.encode64(File.read(Attachment.find($1).diskfile))
    else
      project.portfolio_image
    end
  end

  def portfolio_image_for(project)
    image_tag(portfolio_image_src_for(project), :title => project.portfolio_name)
  end

  def mobile_info_toggler
    link_to image_tag('info.png', :plugin => 'portfolio'), "#", :id => 'mobile-info-toggler', :data => { :active => 'info_active.png', :inactive => 'info.png'}
  end
end
