Redmine::Plugin.register :portfolio do
  name 'Redmine portfolio'
  author 'Lleir Borras Metje'
  description 'This plugin presents a sort of projects in a portfolio page'
  version '0.3.0'
  url 'http://github.com/ifad/redmine-portfolio'
  author_url 'http://github.com/lleirborras'

  requires_redmine :version_or_higher => '2.4.0'

  settings(:partial => 'portfolio/settings', :default => {
    :enabled => true,
    :public_access => false,
    :title => 'Projects portfolio',
    :name_attribute => 'Portfolio name',
    :presence_attribute => 'In portfolio?',
    :image_attribute => 'Portfolio image'
  })
end

ActionDispatch::Callbacks.to_prepare do
  require 'project'

  Project.send(:include, Portfolio::Redmine::Project)
end
