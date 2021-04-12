# frozen_string_literal: true

require 'spec_helper'
require 'generators/solidus_starter_frontend/views/override_generator'

RSpec.describe SolidusStarterFrontend::Views::OverrideGenerator do
  include SolidusStarterFrontend::TestingSupport::Generators

  def src
    SolidusStarterFrontend::Engine.root.join('app', 'views', 'spree')
  end

  def dest
    root.join('app', 'views', 'spree')
  end

  def ensure_clean_state
    FileUtils.rm_rf dest if File.exist?(dest)
  end

  around(:each) do |example|
    ensure_clean_state
    example.run
    ensure_clean_state
  end

  context 'without any arguments' do
    it 'copies all views into the host app' do
      run 'solidus_starter_frontend:views:override'

      expect(src.entries).to match_array(dest.entries)
    end
  end

  context 'when "products" is passed as --only argument' do
    context 'as folder' do
      it 'exclusively copies views whose name contains "products"' do
        run 'solidus_starter_frontend:views:override --only products'

        Dir.glob(dest.join('**', '*')).each do |file|
          next if File.directory?(file)

          expect(file.to_s).to match('products')
        end
      end
    end
  end
end
