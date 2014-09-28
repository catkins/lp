require 'spec_helper'

describe Destination do
  let(:destinations_file_path) { File.expand_path('../../data/destinations.xml', __FILE__) }
  let(:destinations_file) { File.open destinations_file_path }
  let(:xml) { Nokogiri.XML(destinations_file).xpath('//destination').first }

  subject(:destination) { Destination.new xml }

  it { should_not be_nil }
  it { should respond_to :sections }
  it { should respond_to :file_name }

  describe "XML attributes" do
    describe '#title' do
      it { should respond_to :title }

      it 'is read from xml attribute' do
        expect(subject.title).to eq xml.attr('title')
      end
    end

    describe '#atlas_id' do
      it { should respond_to :atlas_id }

      it 'is read from xml attribute' do
        expect(subject.atlas_id).to eq xml.attr('atlas_id')
      end
    end

    describe '#asset_id' do
      it { should respond_to :asset_id }

      it 'is read from xml attribute' do
        expect(subject.asset_id).to eq xml.attr('asset_id')
      end
    end

    describe '#title' do
      it 'is read from xml attribute' do
        expect(subject.title).to eq xml.attr('title')
      end
    end
  end

  describe '#name' do
    it { should respond_to :name }

    it 'is an alias for #title' do
      expect(subject.name).to eq subject.title
    end
  end

  describe '#slug' do
    it { should respond_to :slug }

    it "contains the destination's name downcased and dasherised" do
      processed_name = subject.name.downcase.gsub(' ', '-')
      expect(subject.slug).to include processed_name
    end

    it "contains the destination's atlas_id" do
      expect(subject.slug).to include subject.atlas_id
    end
  end

  describe '#file_name' do
    it { should respond_to :file_name }

    it "contains the destination's slug" do
      expect(subject.file_name).to include subject.slug
    end

    it "is an .html file" do
      expect(File.extname(subject.file_name)).to eq '.html'
    end
  end

  describe '#sections' do
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
