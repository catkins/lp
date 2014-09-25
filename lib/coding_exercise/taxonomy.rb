class Taxonomy
  attr_reader :xml

  def initialize(xml)
    @xml = xml
  end

  def name
    xml.at('taxonomy_name').text
  end

  def ancestors
    []
  end

  def children
    xml.xpath('node').lazy.map do |node|
      TaxonomyNode.new node, self
    end
  end


  def traverse(&block)
    yield self

    children.each do |child|
      child.traverse &block
    end
  end
end
