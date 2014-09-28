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

  it { is_expected.to respond_to :renderer }
  it { is_expected.to respond_to :destination_parser }
  it { is_expected.to respond_to :taxonomy_parser }

  describe '#call' do
    let(:taxonomy_node) { instance_double 'TaxonomyNode', atlas_id: '1234' }
    let(:destination) { instance_double 'Destination' }

    before(:each) do
      allow(taxonomy_parser).to receive(:traverse).and_yield taxonomy_node
      allow(destination_parser).to receive(:find_by_atlas_id).and_return(destination)
    end

    it { is_expected.to respond_to :call }

  end
end
