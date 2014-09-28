# Lonely Planet Coding Exercise

## Prerequisites

- Ruby 2.1.1 - `rbenv install 2.1.1`

## Libraries used

- [Thor](http://whatisthor.com/) - CLI tooling
- [Nokogiri](http://nokogiri.org/) - XML Parsing
- [Rspec](http://rspec.info/) - Unit Testing
- [Pry](http://pryrepl.org/) - IRB Alternative

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

### Commands

`bin/processor build` - Build the static site. By default outputs the generated pages to `./dist`

`bin/processor clean` - Removes the output directory

`bin/processor help [COMMAND]` - Shows usage instruction, and details about arguments.

To run the batch processor against the provided sample files, run the following command in the repository root.

```
bin/processor -t spec/data/taxonomy.xml -d spec/data/destinations.xml
```

## Running the specs

```
bundle exec rake
```

## Overview

A lot of the heavy lifting in this solution is pushed onto Nokogiri, and makes a lot of use of its XPath querying.


I created a lightweight internal DSL to help me decouple the xml structure, and the structure of the documents to be output.

```ruby
# lib/coding_exercise/destination.rb

ContentBuilder.new(xml).build do

  section 'Introduction',               'introductory//text()'

  section 'Practical information' do
    section 'Health and Safety' do
      section 'Before you go',          'practical_information//before_you_go/text()'
      # ...
    end
  end

  section 'Weather',                    'weather//when_to_go/overview/text()' do
    section 'Climate',                  'weather//when_to_go/climate/text()'
  end

  # ...
end
```

## Problem spec

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
