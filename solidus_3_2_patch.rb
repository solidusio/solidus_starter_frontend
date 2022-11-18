# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/app_base'
require 'generators/solidus/install/install_generator/install_frontend'

module SSFSolidus32Patch
  def call(frontend)
    case frontend
    when 'solidus_frontend'
      install_solidus_frontend
    when 'solidus_starter_frontend'
      install_solidus_starter_frontend
    else
      # Adapted from #install_solidus_starter_frontend
      @bundler_context.remove(['solidus_frontend']) if @bundler_context.component_in_gemfile?(:frontend)
      @generator_context.apply ENV['FRONTEND'] or abort("Frontend installation failed.")
    end
  end

  puts "Patching Solidus 3.2 to allow custom frontend templates via the FRONTEND environment variable..."
  Solidus::InstallGenerator::InstallFrontend.prepend self
end
