# Lonely Planet Coding Exercise

## Problem description

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
  a. Readability.
  b. Simplicity.
  c. Extensibility.
  d. Reliability.
  e. Performance (run against the larger dataset).

Feedback at this stage will be provided to all candidates if requested.

If the code evaluation goes well we will invite you in to implement some new requirements within your original project. You can choose to bring in your own laptop with your development environment loaded if you are more comfortable with that, or we can provide you with an iMac and Sublime Text 2.

If you have any questions about this test feel free to email: adel.smee@lonelyplanet.com.au.
