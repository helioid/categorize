class GramCollection
  attr_reader :grams, :content_to_frequency, :content
  attr_accessor :fitness

  def initialize(content, words, invalid)
    @fitness = {}
    @content = content
    @invalid = invalid

    # TODO: n grammify this
    last_word = nil
    last_2nd_word = nil

    @grams = {}
    @content_to_frequency = words.inject({}) do |hash, word|
      bigram = trigram = nil
      if last_word && last_word != word
        bigram = "#{last_word} #{word}"
        if last_2nd_word && word != last_2nd_word
          trigram = "#{last_2nd_word} #{bigram}"
        end
      end

      for gram in [word, bigram, trigram].compact
        next if @invalid.call(gram)
        if hash[gram]
          hash[gram] += 1
          @grams[gram].frequency += 1
        else
          hash[gram] = 1
          @grams[gram] = GramNode.new(self, gram, 1)
        end
      end
      last_2nd_word = last_word
      last_word = word
      hash
    end

    @grams = @grams.values
  end
end

