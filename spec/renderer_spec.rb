require 'spec_helper'

describe Renderer do

  let(:template) do
    <<-HTML
    <!DOCTYPE html>
    <html>
      <body>
        <header>
          <nav>
            <a id="parent" href="<%= link_to taxonomy.parent %>">
              <%= taxonomy.parent.name %>
            </a>
          </nav>
        </header>

        <article>
          <h1><%= destination.name %></h1>
          <p>Lorem ipsum</p>
        </article>
      </body>
    </html>

    HTML
  end

  subject(:renderer) { Renderer.new template }

  it { is_expected.not_to be_nil }
  it { is_expected.to respond_to :render }
  it { is_expected.to respond_to :template }

  describe '#render' do
    let(:destination) { instance_double('Destination', name: 'Cootamundra') }
    let(:parent) { instance_double('TaxonomyNode', name: 'New South Wales', slug: '123-nsw' ) }
    let(:taxonomy) { instance_double('TaxonomyNode', parent: parent) }
    let(:html) { subject.render(destination, taxonomy) }
    let(:document) { Nokogiri.HTML(html) { |config| config.strict.noblanks } }

    def element_at(selector)
      document.css selector
    end

    it 'return a String' do
      expect(html).to be_a String
    end

    it 'renders properties from the destination' do
      expect(element_at('article h1').text).to include destination.name
    end

    it 'renders properties from the taxonomy' do
      expect(element_at('header nav').text).to include parent.name
    end

    it 'renders links based on slug' do
      href = element_at('a#parent:first').attr('href').text
      expect(href).to include parent.slug
    end
  end

end
