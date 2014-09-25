class Taxonomy
  attr_reader :xml

  def initialize(xml)
    @xml = xml
  end

  def name
    xml.at('taxonomy_name').text
  end

  def nodes
    xml.xpath('node').lazy.map do |node|
      TaxonomyNode.new node
    end
  end


  def traverse(&block)
    nodes.each do |node|
      node.traverse &block
    end
  end
end
