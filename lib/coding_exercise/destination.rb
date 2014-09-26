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

  def slug
    dasherised_name = name.downcase.gsub(' ', '-')
    "#{atlas_id}-#{dasherised_name}"
  end

  def file_name
    "#{slug}.html"
  end

  def introduction
    xml.xpath('introductory/introduction/overview').children.first.text.split("\n\n")
  end
end
