# encoding: utf-8

require 'spec_helper'

module Categorize
  describe Model do
    before :each do
      documents = DocumentHelper::Documents

      @doc_multiplier = 5
      @strings = documents.join(' ').downcase.split(/\W/)
      @documents = documents * @doc_multiplier
    end

    it 'categorizes based on number of documents' do
      query = 'test'
      results = Model.make_model(query, @documents)

      results.each do |category, documents|
        @strings.should include(category)
        @doc_multiplier.should eq(documents.length)
      end
    end

    it 'categorizes helioid' do
      documents = [
        %q(Using Helioid search refinement tools you can find and explore what
           you are looking for by interactively narrowing your search results.
           Helioid is a visual search),
        %q(Helioid is a visual search and aggregation tool that enables
           information exploration. Using Helioid's search refinement tools you
           can find.),
        %q(The floor of Silicon Valley is littered with the carcasses of failed
           search startups. Without billions of dollars in resources like
           Microsoft or a tight),
        %q(Dictionary of Difficult Words - helioid. helioid. a. like the sun.
           Find a word. Find a difficult word here. Click on a letter to find
           the word: A B C D E F G H I J K L M N),
        %q(Welcome to the company profile of Helioid on LinkedIn. Using
           Helioid's search refinement tools you can find and explore what
           you're looking for by)
      ]

      bag_of_words = Models::BagOfWords.new
      bag_of_words.max_buckets = 3
      bag_of_words.min_support = 0.4

      results = Model.make_model('helioid', documents, bag_of_words)

      puts results
    end
  end
end
