require 'spec_helper'

describe DestinationParser do

  let(:destinations_file_path) { File.expand_path('../data/destinations.xml', __FILE__) }
  let(:destinations_file) { File.open destinations_file_path }

  after(:each) { destinations_file.close }

  subject(:parser) { DestinationParser.new destinations_file }

  it { is_expected.not_to be_nil }
  it { is_expected.to be_valid }

  describe '#destinations' do
    it { should respond_to :destinations }

    it 'returns an Enumerable' do
      expect(subject.destinations).to be_a Enumerable
    end

    it 'returns elements that are instances of Destination' do
      expect(subject.destinations.first).to be_a Destination
    end
  end
end