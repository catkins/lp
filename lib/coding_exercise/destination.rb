class Destination

  attr_reader :xml

  def initialize(xml)
    @xml = xml
  end

  def atlas_id
    @xml.attr 'atlas_id'
  end

  def asset_id
    @xml.attr 'asset_id'
  end

  def title
    @xml.attr 'title'
  end
end
