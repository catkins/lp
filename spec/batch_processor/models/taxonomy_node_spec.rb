require 'spec_helper'

module BatchProcessor
  describe TaxonomyNode do
    let(:taxonomy_file) { File.open TAXONOMY_FILE_PATH }
    let(:xml) { Nokogiri.XML(taxonomy_file).xpath('/taxonomies//node').first }

    subject(:taxonomy_node) { TaxonomyNode.new xml }

    it { is_expected.not_to be_nil }

    describe 'xml attributes' do
      describe "#atlas_node_id" do
        it { is_expected.to respond_to :atlas_node_id }

        its(:atlas_node_id) { is_expected.to eq xml.attr('atlas_node_id') }
      end

      describe "#ethyl_content_object_id" do
        it { is_expected.to respond_to :ethyl_content_object_id }

        its(:ethyl_content_object_id) { is_expected.to eq xml.attr('ethyl_content_object_id') }
      end

      describe '#name' do
        it { is_expected.to respond_to :name }

        its(:name) { is_expected.to eq xml.xpath('node_name').text }
      end
    end

    describe '#atlas_id' do
      it { is_expected.to respond_to :atlas_id }

      its(:atlas_id) { is_expected.to eq subject.atlas_node_id }
    end
    describe '#file_name' do
      it { is_expected.to respond_to :file_name }
      its(:file_name) { is_expected.to include subject.atlas_id }
    end

    describe '#ancestors' do
      context 'with a parent' do
        subject(:child) { taxonomy_node.children.first }

        its(:ancestors) { is_expected.to match_array [ taxonomy_node ] }
      end

      context 'with no parent' do
        its(:ancestors) { is_expected.to match_array [] }
      end
    end
  end
end
