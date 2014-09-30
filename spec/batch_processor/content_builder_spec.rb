require 'spec_helper'
module BatchProcessor
  describe ContentBuilder do
    let(:content_file_path) { File.expand_path('../../data/content.xml', __FILE__) }
    let(:content_file)      { File.open content_file_path }
    after(:each)            { content_file.close }
    let(:xml)               { Nokogiri.XML(content_file).xpath('//articles/article').first }

    subject(:subject)       { ContentBuilder.new xml }

    it { is_expected.to respond_to :sections }
    it { is_expected.to respond_to :section }
    it { is_expected.to respond_to :xml }

    describe '#build' do
      let(:sections) do
        subject.build do
          section 'Introduction', 'introduction/overview/text()'
          section 'Middle' do
            section 'content', '//middle/content/text()'
          end
          section 'End', 'end/text()'
        end
      end

      it 'takes a block' do
        expect { |b| subject.build(&b) }.to yield_control
      end

      it 'returns an Enumerable' do
        expect(sections).to be_a Enumerable
      end

      it 'has the of the expected top level sections' do
        expect(sections.length).to eq 3
      end
    end

  end
end
