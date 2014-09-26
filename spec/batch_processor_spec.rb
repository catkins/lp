require 'spec_helper'

describe BatchProcessor do
  it { is_expected.to respond_to :template }
  it { is_expected.to respond_to :destination_parser }
  it { is_expected.to respond_to :taxonomy_parser }
end
