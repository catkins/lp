class Destination
  include XmlHelpers

  attr_reader :xml

  xml_attributes :atlas_id, :asset_id, :title

  def initialize(xml)
    @xml = xml
  end

  def name
    title
  end
end
