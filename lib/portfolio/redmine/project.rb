module Portfolio
  module Redmine
    module Project
      extend ActiveSupport::Concern

      included do
        has_many :portfolio_name_custom_values,
          :as => :customized,
          :class_name => 'CustomValue',
          :include => :custom_field,
          :conditions => {
            :custom_values => {
              :custom_field_id => Portfolio::Redmine.name_attribute.id
            }
          }

        scope :portfolio, lambda {
          eager_load(:portfolio_name_custom_values).in_portfolio.sorted_by_portfolio_name
        }

        scope :in_portfolio, lambda {
          where(id: Portfolio::Redmine.presence_attribute.custom_values.where(value: '1').select(:customized_id))
        }

        scope :sorted_by_portfolio_name, lambda {
          order("LOWER(CASE WHEN custom_values.custom_field_id = #{Portfolio::Redmine.name_attribute.id} AND custom_values.value is not null AND custom_values.value != '' THEN custom_values.value ELSE projects.name END) ASC")
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
