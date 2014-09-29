require 'spec_helper'

describe BatchProcessor do
  let(:renderer) { instance_double 'Renderer', render: 'Rendered Template' }
  let(:destination_parser) { instance_double 'DestinationParser' }
  let(:taxonomy_parser) { instance_double 'TaxonomyParser', traverse: nil }
  let(:output_dir) { '' }

  subject(:subject) do
    BatchProcessor.new({
      destination_parser: destination_parser,
      taxonomy_parser: taxonomy_parser,
      renderer: renderer,
      output_dir: output_dir
    })
  end

  describe '#renderer' do
    it { is_expected.to respond_to :renderer }
    its(:renderer) { is_expected.to eq renderer }
  end

  describe '#destination_parser' do
    it { is_expected.to respond_to :destination_parser }
    its(:destination_parser) { is_expected.to eq destination_parser }
  end

  describe '#taxonomy_parser' do
    it { is_expected.to respond_to :taxonomy_parser }
    its(:taxonomy_parser) { is_expected.to eq taxonomy_parser }
  end

  describe '#call' do
    it { is_expected.to respond_to :call }

    let(:first_node) { instance_double 'TaxonomyNode', atlas_id: '1234' }
    let(:second_node) { instance_double 'TaxonomyNode', atlas_id: '5678' }
    let(:first_destination) { instance_double 'Destination' }
    let(:second_destination) { instance_double 'Destination' }

    before(:each) do
      allow(taxonomy_parser).to receive(:traverse).and_yield(first_node).and_yield(second_node)
      allow(destination_parser).to receive(:find_by_atlas_id).with('1234').and_return(first_destination)
      allow(destination_parser).to receive(:find_by_atlas_id).with('5678').and_return(second_destination)
    end

    it 'yields the rendered template, and the current destination for each iteration of the taxonomy traversal' do
      first_args  = [String, first_destination]
      second_args = [String, second_destination]
      expect { |b| subject.call(&b) }.to yield_successive_args(first_args, second_args)
    end
  end
end
