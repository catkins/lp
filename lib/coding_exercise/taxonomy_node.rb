class TaxonomyNode
  include XmlHelpers

  xml_attributes :atlas_node_id, :ethyl_content_object_id

  attr_reader :xml, :parent

  def initialize(xml, parent = nil)
    @xml    = xml
    @parent = parent
  end

  def name
    xml.at('node_name').text
  end

  def atlas_id
    atlas_node_id
  end

  def ancestors
    if parent.nil?
      []
    else
      parent.ancestors + [ parent ]
    end
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
