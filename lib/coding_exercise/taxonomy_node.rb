class TaxonomyNode
  attr_reader :xml, :parent

  def initialize(xml, parent = nil)
    @xml    = xml
    @parent = parent
  end

  def name
    xml.at('node_name').text
  end

  def ancestors
    if parent.nil?
      []
    else
      parent.ancestors + [ parent ]
    end
  end

  def node_id
    xml.attr 'atlas_node_id'
  end

  def ethyl_content_object_id
    xml.attr 'ethyl_content_object_id'
  end

  def children
    xml.xpath('node').lazy.map do |node|
      TaxonomyNode.new node, self
    end
  end
end
