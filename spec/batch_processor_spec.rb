require 'spec_helper'

describe BatchProcessor do
  let(:renderer) { instance_double 'Renderer' }
  let(:destination_parser) { instance_double 'DestinationParser' }
  let(:taxonomy_parser) { instance_double 'TaxonomyParser' }
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
  it { is_expected.to respond_to :call }
end
