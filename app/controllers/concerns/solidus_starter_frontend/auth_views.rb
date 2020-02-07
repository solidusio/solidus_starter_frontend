# frozen_string_literal: true

module SolidusStarterFrontend
  module AuthViews
    extend ActiveSupport::Concern
    included do
      before_action :configure_views
    end

    protected

    def configure_views
      prepend_view_path Engine.root.join('lib', 'views', 'auth')
    end
  end
end
