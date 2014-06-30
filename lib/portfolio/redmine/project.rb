module Portfolio
  module Redmine
    module Project
      extend ActiveSupport::Concern

      included do
        scope :portfolio, lambda {
          in_portfolio.with_portfolio_image.sorted_by_portfolio_name
        }

        scope :in_portfolio, lambda {
          where(id: Portfolio::Redmine.presence_attribute.custom_values.where(value: '1').select(:customized_id))
        }

        scope :with_portfolio_image, lambda {
          where(id: Portfolio::Redmine.image_attribute.custom_values.where("NULLIF(value, '') is not null").select(:customized_id))
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
          custom_values.where(custom_field_id: key).where("value is not null and value != ''").first
        end

        def portfolio_expire_cache
          ActionController::Base.new.expire_fragment('portfolio_view')
        end

    end
  end
end
