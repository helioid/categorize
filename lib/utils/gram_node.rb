class GramNode
  attr_reader :content, :gram_collection
  attr_accessor :frequency

  def initialize(gram_collection, content, frequency=0)
    @gram_group = gram_collection
    @content = content
    @frequency = frequency
  end
end

