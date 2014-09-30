require 'spec_helper'

describe TemplateHelpers do
  let(:dummy_class) { Class.new { include TemplateHelpers } }
  subject(:dummy_instance) { dummy_class.new }
  let(:malicious_text) { "<script type=\"text/javascript\">alert('');</script>" }

  it { is_expected.not_to be_nil }

  describe '#render_paragraphs' do
    let(:paragraphs) { ['Hello', 'World'] }
    it { is_expected.to respond_to :render_paragraphs }

    it 'returns a rendered string of html' do
      expect(subject.render_paragraphs(paragraphs)).to be_a String
    end

    it 'is split into new lines' do
      lines = subject.render_paragraphs(paragraphs).lines
      expect(lines).to have(2).items
    end

    it 'renders each line in a pararaph tag' do
      lines = subject.render_paragraphs(paragraphs).lines
      expect(lines.first).to match /<p>.*<\/p>/
      expect(lines.last).to match /<p>.*<\/p>/
    end

    it 'escapes any html in the paragraphs' do
      safe_paragraph = ERB::Util.html_escape malicious_text

      expect(subject.render_paragraphs([malicious_text])).to include safe_paragraph
    end
  end

  describe '#render_heading_for_section' do
    let(:section) { instance_double('ContentBuilder::ContentSection', title: 'Weather', depth: 4) }

    it { is_expected.to respond_to :render_heading_for_section }

    it 'wraps line in heading matching given depth' do
      html = subject.render_heading_for_section section
      expect(html).to match /<h4>.*<\/h4>/
    end

    it 'escapes any html in the heading' do
      safe_heading = ERB::Util.html_escape malicious_text
      allow(section).to receive(:title).and_return(malicious_text)

      expect(subject.render_heading_for_section(section)).to include safe_heading
    end
  end

  describe "#render_section" do
    it { is_expected.to respond_to :render_section }

    context 'with empty section' do
      let(:section) { instance_double('ContentBuilder::ContentSection', empty?: true) }

      it 'renders an empty string' do
        expect(subject.render_section(section)).to eq ''
      end
    end

    context 'with paragraphs' do
      let(:paragraphs) { [ "Really quite cold.", "Wear a raincoat." ] }
      let(:section) do
        instance_double 'ContentBuilder::ContentSection',
                        empty?: false, title: 'Weather',
                        paragraphs: paragraphs, depth: 1,
                        sub_sections: []
      end
      let(:html) { subject.render_section(section) }

      it "includes the paragraph content" do
        expect(html).to include paragraphs.first
        expect(html).to include paragraphs.last
      end
    end

    context 'with sub sections' do
      let(:paragraphs) { [ "Really quite cold." ] }
      let(:child_section) do
        instance_double 'ContentBuilder::ContentSection',
                        empty?: false, title: 'In winter',
                        paragraphs: paragraphs, depth: 2,
                        sub_sections: []
      end
      let(:section) do
        instance_double 'ContentBuilder::ContentSection',
                        empty?: false, title: 'Weather',
                        paragraphs: [], depth: 1,
                        sub_sections: [ child_section ]
      end

      let(:html) { subject.render_section(section) }

      it "includes the sub section content" do
        child_content = subject.render_section(child_section)
        expect(html).to include child_content
      end
    end
  end
end
