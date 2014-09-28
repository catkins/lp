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
    @sections ||= ContentBuilder.build(xml) do

      section 'Introduction',             'introductory//text()'

      section 'History',                    'history//overview//text()' do
        section 'History',                  'history//history/history//text()'
      end

      section 'Practical information' do
        section 'Health and Safety' do
          section 'Before you go',          'practical_information//before_you_go/text()'
          section 'Dangers and annoyances', 'practical_information//dangers_and_annoyances/text()'
          section 'In transit',             'practical_information//in_transit/text()'
          section "While you're there",     'practical_information//while_youre_there/text()'
        end

        section 'Money and Costs' do
          section 'Costs',                  'practical_information//money_and_costs/costs/text()'
          section 'Money',                  'practical_information//money_and_costs/money/text()'
        end

        section 'Visas',                    'practical_information//visas/overview/text()' do
          section 'Other',                  'practical_information//visas/other/text()'
        end
      end

      section 'Transport' do
        section 'Getting Around',           'transport//getting_around/overview/text()' do
          section 'Air',                    'transport//getting_around/air/text()'
          section 'Bicycle',                'transport//getting_around/bicycle/text()'
          section 'Car and Motorcycle',     'transport//getting_around/car_and_motorcycle/text()'
          section 'Local Transport',        'transport//getting_around/local_transport/text()'
          section 'Train',                  'transport//getting_around/train/text()'
        end

        section 'Getting There and Away' do
          section 'Air',                    'transport//getting_there_and_away/air/text()'
        end
      end

      section 'Weather',                    'weather//when_to_go/overview/text()' do
        section 'Climate',                  'weather//when_to_go/climate/text()'
      end

      section 'Work / Live / Study' do
        section 'Work',                     'work_live_study/work/overview/text()' do
          section 'Business',               'work_live_study/work/business/text()'
        end
      end
    end
  end
end
