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

  def sections
    @sections ||= ContentBuilder.build(xml) do |cb|

      cb.section(title) do |s|
        s.sub_section 'Introduction',           'introductory//text()'
      end

      cb.section 'Health and Safety' do |s|
        s.sub_section 'Before you go',          'practical_information//before_you_go/text()'
        s.sub_section 'Dangers and annoyances', 'practical_information//dangers_and_annoyances/text()'
        s.sub_section 'In transit',             'practical_information//in_transit/text()'
        s.sub_section "While you're there",     'practical_information//while_youre_there/text()'

      end

      cb.section 'Money and Costs' do |s|
        s.sub_section 'Costs',                  'practical_information//money_and_costs/costs/text()'
        s.sub_section 'Money',                  'practical_information//money_and_costs/money/text()'
      end

      cb.section 'Getting Around' do |s|
        s.sub_section 'Overview',               'transport//getting_around/overview/text()'
        s.sub_section 'Air',                    'transport//getting_around/air/text()'
        s.sub_section 'Bicycle',                'transport//getting_around/bicycle/text()'
        s.sub_section 'Car and Motorcycle',     'transport//getting_around/car_and_motorcycle/text()'
        s.sub_section 'Local Transport',        'transport//getting_around/local_transport/text()'
        s.sub_section 'Train',                  'transport//getting_around/train/text()'
      end

      cb.section 'Getting There and Away' do |s|
        s.sub_section 'Air',                    'transport//getting_there_and_away/air/text()'
      end

      cb.section 'Weather' do |s|
        s.sub_section 'Overview',               'weather//when_to_go/overview/text()'
        s.sub_section 'Climate',                'weather//when_to_go/climate/text()'
      end
    end
  end


  class ContentBuilder
    attr_reader :xml, :sections

    class << self
      def build(xml, &block)
        yield new(xml)
      end
    end

    def section(title, &block)
      section = Section.new title, xml
      yield section

      sections << section
    end

    def initialize(xml)
      @xml = xml
      @sections = []
    end
  end


  class Section
    attr_reader :title, :sub_sections, :xml

    def initialize(title, xml)
      @title = title
      @xml = xml
      @sub_sections = []
    end

    def sub_section(title, expression)
      paragraphs = xml.xpath(expression).map(&:text)

      if paragraphs.any?
        sub_sections << SubSection.new(title, paragraphs)
      end
    end
  end

  class SubSection < Struct.new(:title, :paragraphs)
  end
end
