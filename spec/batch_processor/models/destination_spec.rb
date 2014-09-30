require 'spec_helper'

module BatchProcessor
  describe Destination do
    let(:destinations_file) { File.open DESTINATIONS_FILE_PATH }

    let(:xml) { Nokogiri.XML(destinations_file).xpath('//destination').first }

    subject(:destination) { Destination.new xml }

    it { is_expected.not_to be_nil }

    describe "XML attributes" do
      describe '#title' do
        it { is_expected.to respond_to :title }

        its(:title) { is_expected.to eq xml.attr('title') }
      end

      describe '#atlas_id' do
        it { is_expected.to respond_to :atlas_id }

        its(:atlas_id) { is_expected.to eq xml.attr('atlas_id') }
      end

      describe '#asset_id' do
        it { is_expected.to respond_to :asset_id }

        its(:asset_id) { is_expected.to eq xml.attr('asset_id') }
      end
    end

    describe '#name' do
      it { is_expected.to respond_to :name }

      its(:name) { is_expected.to eq subject.title }
    end

    describe '#file_name' do
      it { is_expected.to respond_to :file_name }

      its(:file_name) { is_expected.to include subject.atlas_id }

      it "is an .html file name" do
        expect(File.extname(subject.file_name)).to eq '.html'
      end
    end

    describe '#sections' do
      it { is_expected.to respond_to :sections }

      describe 'top level sections' do
        let(:sections) { subject.sections }

        it 'are all present' do
          headings = [
            'Introduction',
            'History',
            'Practical information',
            'Transport',
            'Weather',
            'Work / Live / Study'
          ]

          expect(sections.map(&:title)).to match_array headings
        end

      end
    end
  end
end
