require 'nokogiri'

module PortfolioHelper

  def portfolio_image_src_for(project)
    if project.portfolio_image =~ /\/attachments\/download\/(\d+)\/.+\.(\w+)$/i
      "data:image/#{$2};base64," + Base64.encode64((File.read(Attachment.find($1).diskfile) rescue ''))
    else
      project.portfolio_image
    end

  rescue ActiveRecord::RecordNotFound
    ''
  end

  def portfolio_mobile_info_toggler
    link_to image_tag('info.png', :plugin => 'portfolio'), "#", :id => 'mobile-info-toggler', :data => { :active => 'info_active.png', :inactive => 'info.png'}
  end

  def portfolio_plain_description(project)
    Nokogiri::HTML(textilizable(project.description, :project => project)).text
  end

  def portfolio_tokens(project)
    Nokogiri::HTML(textilizable(project.portfolio_tokens, :project => project)).text
  end

end
