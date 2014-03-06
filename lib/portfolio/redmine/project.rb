module Portfolio
  module Redmine
    module Project
      extend ActiveSupport::Concern

      def portfolio_image
        if image_field = portfolio_custom_field_for(Portfolio::Redmine.image_attribute.id)
          image_field.value
        end
      end

      def portfolio_name
        if name_field = portfolio_custom_field_for(Portfolio::Redmine.name_attribute.id)
          name_field.value
        else
          name
        end
      end

      protected
        def portfolio_custom_field_for(key)
          custom_values.where(custom_field_id: key).where("value is not null and value != ''").first
        end

    end
  end
end
