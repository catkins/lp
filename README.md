# Lonely Planet Coding Exercise

## Prerequisites

- Ruby 2.1.1 - `rbenv install 2.1.1`
- Bundler

## Installation

```bash
# clone the repo
git clone git@github.com:catkins/lp.git
cd lp

# install the dependencies
bundle install
```

## Usage

This application is built around a Thor CLI client at `bin/processor`

## Commands

### Build

`bin/processor build` - Build the static site. By default outputs the generated pages to `./dist`

```
-t, --taxonomy=PATH_TO_TAXONOMY_XML
-d, --destinations=PATH_TO_DESTINATIONS_XML
-o, [--output=OUTPUT_DIRECTORY] # optional
```

### Clean

`bin/processor clean` - Removes the output directory

Flags
```
-o, [--output=OUTPUT_DIRECTORY] # optional
```

### Help

`bin/processor help [COMMAND]` - Shows usage instruction, and details about arguments. (Built into Thor)

To run the batch processor against the provided sample files, run the following command in the repository root.

```bash
bin/processor -t spec/data/taxonomy.xml -d spec/data/destinations.xml
```


## Libraries used

- [Nokogiri](http://nokogiri.org/) - XML Parsing
- [Thor](http://whatisthor.com/) - CLI tooling
- [Rspec](http://rspec.info/) - Unit Testing
- [RSpec Mocks](https://relishapp.com/rspec/rspec-mocks/docs) - Mocking and Stubbing
- [FakeFS](https://github.com/defunkt/fakefs) - Mocking for the local file system
- [Simplecov](https://github.com/colszowka/simplecov) - Code coverage analysis
- [Pry](http://pryrepl.org/) - IRB Alternative

## Running the specs

```bash
bundle exec rake

# or

bundle exec rspec
```

## Overview

A lot of the heavy lifting in this solution is pushed onto `Nokogiri`, and makes a lot of use of its XPath querying.

I created a lightweight internal DSL to help me decouple the xml structure, and the structure of the documents to be output. This allowed me to include and structure the output documents in a flexible and declarative manner, just declaring the headings, document hierarchy and the xpaths for any text content if required. The DSL is implemented in `lib/content_builder`, and is not specific to these xml files, or generated documents.

```ruby
# lib/coding_exercise/models/destination.rb

ContentBuilder.new(xml).build do

  # a top level section with paragraphs
  section 'Introduction',               'introductory//text()'

  # a section with subheadings, but not text content of its own
  section 'Practical information' do
    section 'Health and Safety' do

      # a nested subsection
      section 'Before you go',          'practical_information//before_you_go/text()'
      # ...
    end
  end

  # a top level section with text content and sub sections
  section 'Weather',                    'weather//when_to_go/overview/text()' do
    section 'Climate',                  'weather//when_to_go/climate/text()'
  end

end
```

I tried to decouple as many of the concerns as I could into a composable whole. The XML parsing is handled in two parser classes in `lib/coding_exercise/parsers`, which in turn delegate out to some domain models in `lib/coding_exercise/models`.

View renderering is handled by ruby's built in `ERB` module, with a bit of light plumbing to make it a bit friendlier to use. The logic there is in `lib/coding_exercise/destination_renderer` and `lib/coding_exercise/helpers/template_helpers.rb`.

The actual running of the application is handled by a `Thor` CLI class defined in `lib/coding_exercise/processor_cli.rb`, with it's executable at `bin/processor`. The CLI class largely just handled orchestration and IO concerns, leaving the application logic in other library classes. This delegates responsibility to the parsers and renderer, and with the `lib/coding_exercise/batch_processor` handling the iteration logic.

## Problem specification

We have two (admittedly not very clean) .xml files from our legacy CMS system - taxonomy.xml holds the information about how destinations are related to each other and destinations.xml holds the actual text content for each destination.

We would like you to create a batch processor that takes these input files and produces an .html file (based on the output template given with this test) for each destination. Each generated web page must have:

1. Some destination text content. Use your own discretion to decide how much information to display on the destination page.
2. Navigation that allows the user to browse to destinations that are higher in the taxonomy. For example, Beijing should have a link to China.
3. Navigation that allows the user to browse to destinations that are lower in the taxonomy. For example, China should have a link to Beijing.

The batch processor should take the location of the two input files and the output directory as parameters.

These sample input files contain only a small subset of destinations.  We will test your software on the full Lonely Planet dataset, which currently consists of almost 30,000 destinations.

To submit your code, either ZIP it up and email it to the address below, or give us a link to your github repo.

When we receive your project the code will be:

1. Built and run against the dataset supplied.
2. Evaluated based on coding style and design choices in all of these areas:

  a) Readability.
  b) Simplicity.
  c) Extensibility.
  d) Reliability.
  e) Performance (run against the larger dataset).
