require 'spec_helper'

describe ProcessorCLI do
  before(:each) do
   FakeFS.activate!
   FakeFS::FileSystem.clear
  end

  after(:each) do
   FakeFS.deactivate!
   FakeFS::FileSystem.clear
  end



end
