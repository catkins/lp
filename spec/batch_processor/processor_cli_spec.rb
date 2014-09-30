require 'spec_helper'

module BatchProcessor
  describe ProcessorCLI do
    before(:each) do
     FakeFS.activate!
     FakeFS::FileSystem.clear
    end

    after(:each) do
     FakeFS.deactivate!
     FakeFS::FileSystem.clear
    end

    describe 'class options' do
      subject(:cli) { ProcessorCLI.new }
      it { is_expected.not_to be_nil }

      it ':output defaults to ProcessorCLI::DEFAULT_OUTPUT_PATH' do
        expect(subject.options[:output]).to eq DEFAULT_OUTPUT_PATH
      end
    end

    describe '#clean' do
      context 'when user accepts warning' do
        before(:each) do
          allow_any_instance_of(Thor::Shell::Basic).to receive(:yes?).and_return true
        end

        context 'default output path' do
          it 'removes the directory at ProcessorCLI::DEFAULT_OUTPUT_PATH' do
            expect(FileUtils).to receive(:rm_rf).with DEFAULT_OUTPUT_PATH

            capture(:stdout) { ProcessorCLI.start %w(clean) }
          end
        end

        context 'overwritten output path' do
          let(:output_path) { 'some/other/path' }

          it "removes the directory at given path" do
            expect(FileUtils).to receive(:rm_rf).with output_path

            capture(:stdout) { ProcessorCLI.start ['clean', '--output', output_path] }
          end
        end
      end

      context 'when user rejects warning' do
        before(:each) { allow_any_instance_of(Thor::Shell::Basic).to receive(:yes?).and_return false }

        it "doesn't remove any files" do
          expect(FileUtils).not_to receive(:rm_rf)
          capture(:stdout) { ProcessorCLI.start %w(clean) }
        end
      end
    end

    describe '#build' do
      let(:output_path)       { 'some/other/path' }
      let(:destinations_path) { 'path/to/destinations.xml' }
      let(:taxonomy_path)     { 'path/to/taxonomy.xml' }

      before(:all) do
        @taxonomy_content     = File.read TAXONOMY_FILE_PATH
        @destinations_content = File.read DESTINATIONS_FILE_PATH
        @template_content     = File.read DEFAULT_TEMPLATE_PATH
      end

      # write outr equired content to fake filesystem
      before(:each) do
        FileUtils.mkdir_p 'path/to'
        FileUtils.mkdir_p File.dirname(DEFAULT_TEMPLATE_PATH)
        FileUtils.mkdir_p STATIC_ASSETS_PATH
        FileUtils.mkdir_p DEFAULT_OUTPUT_PATH

        destinations_file = File.open destinations_path, 'w'
        destinations_file.write @destinations_content

        taxonomy_file = File.open taxonomy_path, 'w'
        taxonomy_file.write @taxonomy_content

        template_file = File.open DEFAULT_TEMPLATE_PATH, 'w'
        template_file.write @template_content

        # stub out ruby-progressbar output
        allow_any_instance_of(ProgressBar::Base).to receive(:output).and_return StringIO.new
      end

      context 'without pre-existing output directory' do
        let(:args) { ['build', '--output', output_path, '-d', destinations_path, '-t', taxonomy_path ] }

        it 'creates the directory' do
          expect(FileUtils).to receive(:mkpath).with(output_path).and_call_original

          capture(:stdout) { ProcessorCLI.start args }
        end

        it 'notifies user of directory creation' do
          out = capture(:stdout) { ProcessorCLI.start args }

          expect(out).to match /Creating #{output_path}/
        end
      end

      context "when destination file doesn't exists" do
        let(:args) { ['build', '--output', output_path, '-d', 'some/bogus/path', '-t', taxonomy_path ] }

        it "aborts with a non-zero exit code" do
          expect {
            capture(:stdout) { ProcessorCLI.start args }
          }.to raise_error SystemExit
        end
      end

      context "when taxonomy file doesn't exists" do
        let(:args) { ['build', '--output', output_path, '-d', destinations_path, '-t', 'some/bogus_path' ] }

        it "aborts with a non-zero exit code" do
          expect {
            capture(:stdout) { ProcessorCLI.start args }
          }.to raise_error SystemExit
        end
      end

      context 'when valid file paths passed' do
        let(:static_assets_path) { STATIC_ASSETS_PATH }
        let(:output_path) { DEFAULT_OUTPUT_PATH }
        let(:args) { ['build', '-d', destinations_path, '-t', taxonomy_path ] }


        it "copies the static assets to the output path" do
          expect(FileUtils).to receive(:cp_r).with static_assets_path, output_path

          capture(:stdout) { ProcessorCLI.start args }
        end

        it 'creates a DestinationRenderer with the template content' do
          expect(DestinationRenderer).to receive(:new).with(@template_content).and_call_original

          capture(:stdout) { ProcessorCLI.start args }
        end

        it "reads the taxonomy file" do
          allow(File).to receive(:open).with(/#{output_path}/, 'w').and_call_original
          allow(File).to receive(:open).with(destinations_path).and_call_original
          expect(File).to receive(:open).with(taxonomy_path).and_call_original

          capture(:stdout) { ProcessorCLI.start args }
        end

        it 'creates a TaxonomyParser with a file handle' do
          expect(TaxonomyParser).to receive(:new).with(File).and_call_original

          capture(:stdout) { ProcessorCLI.start args }
        end

        it "reads the destinations file" do
          allow(File).to receive(:open).with(/#{output_path}/, 'w').and_call_original
          allow(File).to receive(:open).with(taxonomy_path).and_call_original
          expect(File).to receive(:open).with(destinations_path).and_call_original

          capture(:stdout) { ProcessorCLI.start args }
        end

        it 'creates a DestinationParser with a file handle' do
          expect(DestinationParser).to receive(:new).with(File).and_call_original
          capture(:stdout) { ProcessorCLI.start args }
        end

        it "writes files to the output directory" do
          allow(File).to receive(:open).with(any_args).and_call_original
          expect(File).to receive(:open).with(/#{output_path}/, 'w')
          capture(:stdout) { ProcessorCLI.start args }
        end
      end
    end

  end
end
