module Portfolio

  module Redmine
    extend self

    def plugin
      ::Redmine::Plugin.find(:portfolio)
    end

    def settings
      if ActiveRecord::Base.connection.table_exists?(:settings) && self.plugin && Setting.plugin_portfolio
        Setting.plugin_portfolio
      else
        plugin.settings[:default]
      end
    end

    def name_attribute
      custom_field(:name_attribute)
    end

    def presence_attribute
      custom_field(:presence_attribute)
    end

    def image_attribute
      custom_field(:image_attribute)
    end

    def tokens_attribute
      custom_field(:tokens_attribute)
    end

    def custom_code
      settings[:custom_code]
    end

    def custom_css
      settings[:custom_css]
    end

    def title
      settings[:title]
    end

    def enabled?
      settings[:enabled] == 'true'
    end

    def public_access?
      settings[:public_access] == 'true'
    end

    protected
      def custom_field(name)
        CustomField.find_by_name(settings[name.to_sym])
      end

  end

end
