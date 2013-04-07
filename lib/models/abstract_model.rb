class Models::AbstractModel
  require 'ai4r'
  
  def initialize
    @gram_cache = Hash.new(nil)
    @bigram_max_cache = Hash.new(nil)
  end

  def build_vars(records_to_tokens)
    @tokens = records_to_tokens.values
    @labels, @vectors = vectorize(@tokens) 
    build_dataset(@labels, @vectors)
  end

  def vectorize(tokens)
    labels = tokens.flatten.uniq
    vectors = tokens.inject([]) do |ary, tokens|
      items = Array.new(labels.length, 0)
      labels.each_with_index do |token, i|
        items[i] = tokens.count(token)
      end
      ary << items
    end
    [labels, vectors]
  end
  
  def build_dataset(labels, vectors)
    Ai4r::Data::DataSet.new(:data_items => vectors, :data_labels => labels)
  end
end
