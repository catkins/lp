require 'spec_helper'

describe TaxonomyParser do

  let(:taxonomy_file_path) { File.expand_path('../data/taxonomy.xml', __FILE__) }
  let(:taxonomy_file) { File.open taxonomy_file_path }

  after(:each) { taxonomy_file.close }

  subject(:parser) { TaxonomyParser.new taxonomy_file }

  it { is_expected.not_to be_nil }
  it { is_expected.to be_valid }

  describe '#taxonomies' do
    it { is_expected.to respond_to :taxonomies }

    it 'returns an Enumerable' do
      expect(subject.taxonomies).to be_a Enumerable
    end

    it 'returns elements that are instances of Taxonomy' do
      expect(subject.taxonomies.first).to be_a Taxonomy
    end
  end

  describe 'traverse' do
    it 'visits all of the elements in the taxonomy' do
      count = 0
      subject.traverse { |node| count += 1 }
      expect(count).to eq 24
    end
  end
 end
