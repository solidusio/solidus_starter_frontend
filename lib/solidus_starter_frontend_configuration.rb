# frozen_string_literal: true

class SolidusStarterFrontendConfiguration < Spree::Preferences::Configuration
  preference :locale, :string, default: I18n.default_locale

  # Add your terms and conditions in app/views/spree/checkout/_terms_and_conditions.en.html.erb
  preference :require_terms_and_conditions_acceptance, :boolean, default: false
end
