# frozen_string_literal: true

require 'tempfile'
require 'solidus_starter_frontend_helper'
require 'generators/solidus_starter_frontend/enable_code.rb'

module SolidusStarterFrontend
  RSpec.describe EnableCode do
    describe '#call' do
      let(:generator_class) do
        Class.new(Rails::Generators::Base) do
        end
      end

      let(:generator) { generator_class.new([], quiet: true) }

      let!(:tmp_file) do
        Tempfile.new('enable_code_spec').tap do |file|
          file.write(content)
          file.close
        end
      end

      let(:path) { tmp_file.path }

      subject(:service) do
        described_class.new(
          generator: generator,
          namespace: 'SampleGenerator',
          path: path
        )
      end

      describe 'concerning marked Ruby-commented lines' do
        let(:marker) { "# SampleGenerator/line" }

        context 'when a line is empty' do
          let(:content) { '' }

          it 'does nothing' do
            service.call

            expect(File.read(path)).to be_empty
          end
        end

        context 'when a line does not have the marker' do
          let(:content) { '# Not SampleGenerator/line' }

          it 'does nothing' do
            service.call

            expect(File.read(path)).to eq(content)
          end
        end

        context 'when the marker has a comment before it' do
          let(:content) { "# some commented code #{marker}" }

          it 'uncomments the line' do
            service.call

            expect(File.read(path)).to eq('some commented code')
          end
        end

        context 'when the comment has whitespace before it' do
          let(:content) { " # some commented code #{marker}" }

          it 'retains the whitespace before the content' do
            service.call

            expect(File.read(path)).to eq(' some commented code')
          end
        end

        context 'when the line before the comment has trailing whitespace' do
          let(:content) { "preceding line \n# some commented code #{marker}" }

          it 'retains the whitespace' do
            service.call

            expect(File.read(path)).to eq("preceding line \nsome commented code")
          end
        end

        context 'when the line after the comment has leading whitespace' do
          let(:content) { "# some commented code #{marker}\n succeeding line" }

          it 'retains the whitespace' do
            service.call

            expect(File.read(path)).to eq("some commented code\n succeeding line")
          end
        end
      end

      describe 'concerning marked Ruby-commented blocks' do
        let(:block_start_marker) do
          '=begin # SampleGenerator/start'
        end

        let(:block_end_marker) do
          '=end # SampleGenerator/end'
        end

        let(:block_content) { 'Content' }

        let(:block) { [block_start_marker, block_content, block_end_marker].join("\n") }

        context 'when the content is empty' do
          let(:content) { '' }

          it 'does nothing' do
            service.call

            expect(File.read(path)).to be_empty
          end
        end

        context 'when the content does not have a block' do
          let(:content) { '# Not SampleGenerator/start' }

          it 'does nothing' do
            service.call

            expect(File.read(path)).to eq(content)
          end
        end

        context 'when the content only has the block' do
          let(:content) { block }

          it 'uncomments the block' do
            service.call

            expect(File.read(path)).to eq("#{block_content}\n")
          end
        end

        context 'when the line before the block has trailing whitespace' do
          let(:content) { "preceding line \n#{block}" }

          it 'retains the whitespace' do
            service.call

            expect(File.read(path)).to eq("preceding line \n#{block_content}\n")
          end
        end

        context 'when the line after the block has leading whitespace' do
          let(:content) { "#{block}\n succeeding line" }

          it 'retains the whitespace' do
            service.call

            expect(File.read(path)).to eq("#{block_content}\n succeeding line")
          end
        end
      end
    end
  end
end
