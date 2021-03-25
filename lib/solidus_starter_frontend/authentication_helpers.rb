# frozen_string_literal: true

module SolidusStarterFrontend
  module AuthenticationHelpers
    def self.included(receiver)
      if receiver.send(:respond_to?, :helper_method)
        receiver.send(:helper_method, :spree_current_user)

        receiver.send(:helper_method, :spree_login_path)
        receiver.send(:helper_method, :spree_signup_path)
        receiver.send(:helper_method, :spree_logout_path)
      end
    end

    def spree_current_user
      current_spree_user
    end


    delegate :login_path, :signup_path, :logout_path,
              to: :spree,
              prefix: :spree
  end
end
