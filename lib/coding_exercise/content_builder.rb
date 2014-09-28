class ContentBuilder
  attr_reader :xml, :sections

  class << self
    def build(xml, &block)
      builder = ContentBuilder.new(xml)
      builder.instance_eval &block
      builder.sections
    end
  end

  def section(section_title, path = nil, &block)
    depth = 2
    section = ContentSection.new section_title, path, xml, depth

    section.instance_eval(&block) if block_given?
    sections << section unless section.empty?
  end

  def initialize(xml)
    @xml = xml
    @sections = []
  end

  class ContentSection
    attr_reader :title, :path, :sub_sections, :xml, :depth

    def initialize(title, path, xml, depth)
      @title = title
      @path = path
      @xml = xml
      @depth = depth
      @sub_sections = []
    end

    def empty?
      paragraphs.none? && sub_sections.none?
    end

    def paragraphs
      if path
        @paragraphs ||= xml.xpath(path).map(&:text)
      else
        @paragraphs = []
      end
    end

    def section(title, path = nil, &block)
      sub_section = ContentSection.new title, path, xml, (depth + 1)

      sub_section.instance_eval(&block) if block_given?

      sub_sections << sub_section unless sub_section.empty?
    end
  end
end

