module PortfolioHelper

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
