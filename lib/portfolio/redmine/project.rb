module Portfolio
  module Redmine
    module Project
      extend ActiveSupport::Concern

      included do
        scope :portfolio, lambda {
          in_portfolio.with_portfolio_image.sorted_by_portfolio_name
        }

        scope :in_portfolio, lambda {
          joins(%[
            INNER JOIN custom_values portfolio_presence
               ON portfolio_presence.custom_field_id = #{Portfolio::Redmine.presence_attribute.id}
              AND portfolio_presence.customized_type = 'Project'
              AND portfolio_presence.customized_id   = projects.id
          ]).
          where("portfolio_presence.value = '1'")
        }

        scope :with_portfolio_image, lambda {
          joins(%[
            INNER JOIN custom_values portfolio_image
               ON portfolio_image.custom_field_id = #{Portfolio::Redmine.image_attribute.id}
              AND portfolio_image.customized_type = 'Project'
              AND portfolio_image.customized_id   = projects.id
          ]).
          where("NULLIF(portfolio_image.value, '') IS NOT NULL")
        }

        scope :sorted_by_portfolio_name, lambda {
          joins(%[
            LEFT OUTER JOIN custom_values portfolio_name
              ON portfolio_name.custom_field_id = #{Portfolio::Redmine.name_attribute.id}
             AND portfolio_name.customized_type = 'Project'
             AND portfolio_name.customized_id   = projects.id
          ]).
          order("LOWER(COALESCE(NULLIF(portfolio_name.value, ''), projects.name)) ASC")
        }

        after_save :portfolio_expire_cache
      end

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
          custom_values.where(custom_field_id: key).where("NULLIF(value, '') IS NOT NULL").first
        end

        def portfolio_expire_cache
          ActionController::Base.new.expire_fragment('portfolio_view')
        end

    end
  end
end
