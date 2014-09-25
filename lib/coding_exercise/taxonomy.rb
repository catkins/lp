class Taxonomy
  attr_reader :xml

  def initialize(xml)
    @xml = xml
  end

  def name
    xml.at('taxonomy_name').text
  end

  def children
    xml.xpath('node').lazy.map do |node|
      TaxonomyNode.new node
    end
  end
end
