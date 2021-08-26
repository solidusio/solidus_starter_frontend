# frozen_string_literal: true

require 'tempfile'
require 'solidus_starter_frontend_helper'
require 'generators/solidus_starter_frontend/remove_markers.rb'

module SolidusStarterFrontend
  RSpec.describe RemoveMarkers do
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

      describe 'concerning marked uncommented lines' do
        shared_examples 'can remove the marker' do
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

          context 'when a line only has the marker' do
            let(:content) { marker }

            it 'deletes the line' do
              service.call

              expect(File.read(path)).to be_empty
            end
          end

          context 'when the marker has whitespace before it' do
            let(:content) { " #{marker}" }

            it 'deletes the line' do
              service.call

              expect(File.read(path)).to be_empty
            end
          end

          context 'when the marker has content before it' do
            let(:content) { "some content #{marker}" }

            it 'retains the content' do
              service.call

              expect(File.read(path)).to eq('some content')
            end
          end

          context 'when the line before the marker has trailing whitespace' do
            let(:content) { "preceding line \n#{marker}" }

            it 'retains the whitespace' do
              service.call

              expect(File.read(path)).to eq("preceding line \n")
            end
          end

          context 'when there is a line after the marker' do
            let(:content) { "#{marker}\nsucceeding line" }

            it 'retains the newline' do
              service.call

              expect(File.read(path)).to eq("\nsucceeding line")
            end
          end

          context 'when the line after the marker has leading whitespace' do
            let(:content) { "#{marker}\n succeeding line" }

            it 'retains the whitespace' do
              service.call

              expect(File.read(path)).to eq("\n succeeding line")
            end
          end
        end

        context 'when the marker is a ERB comment' do
          let(:marker) { "<%# SampleGenerator/line %>" }

          it_behaves_like 'can remove the marker'
        end

        context 'when the marker is a Ruby comment' do
          let(:marker) { "# SampleGenerator/line" }

          it_behaves_like 'can remove the marker'
        end
      end

      describe 'concerning marked uncommented blocks' do
        shared_examples 'can remove the markers' do
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

            it 'removes the markers' do
              service.call

              expect(File.read(path)).to eq("#{block_content}\n")
            end
          end

          context 'when the start and end markers have spaces before them' do
            let(:block) do
              [
                " #{block_start_marker}",
                block_content,
                " #{block_end_marker}"
              ].join("\n")
            end

            let(:content) { block }

            it 'removes the markers' do
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

        context 'when the marker is a ERB comment' do
          let(:block_start_marker) do
            '<%# SampleGenerator/start %>'
          end

          let(:block_end_marker) do
            '<%# SampleGenerator/end %>'
          end

          it_behaves_like 'can remove the markers'
        end

        context 'when the marker is a Ruby comment' do
          let(:block_start_marker) do
            '# SampleGenerator/start'
          end

          let(:block_end_marker) do
            '# SampleGenerator/end'
          end

          it_behaves_like 'can remove the markers'
        end
      end
    end
  end
end
