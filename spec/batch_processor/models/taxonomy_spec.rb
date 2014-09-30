require 'spec_helper'

module BatchProcessor
  describe Taxonomy do

    let(:taxonomy_file) { File.open TAXONOMY_FILE_PATH }
    let(:xml) { Nokogiri.XML(taxonomy_file).xpath('/taxonomies//taxonomy').first }

    subject(:taxonomy) { Taxonomy.new xml }

    it { is_expected.not_to be_nil }

    describe '#name' do
      it { is_expected.to respond_to :name }
      its(:name) { is_expected.to eq xml.xpath('taxonomy_name').text }
    end

    describe '#nodes' do
      it 'is a list of each top level node' do
        names = xml.xpath('node/node_name').map &:text
        expect(subject.nodes.force.map(&:name)).to eq names
      end
    end

    describe '#traverse' do
      it 'yields once for each child element' do
        child_count = xml.xpath('//node').count

        expect do |b|
          subject.traverse(&b)
        end.to yield_control.exactly(child_count).times
      end
    end
  end
end
