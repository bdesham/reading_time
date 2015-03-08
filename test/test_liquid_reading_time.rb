require 'minitest/autorun'
require 'liquid'
require 'liquid_reading_time'

include ReadingTime

class WordCountingTest < Minitest::Test
	def test_one_word
		assert_equal 1, ReadingTime.count_words('I')
	end

	def test_whitespace
		assert_equal 1, ReadingTime.count_words(' Hello')
		assert_equal 1, ReadingTime.count_words('Supercalifragilisticexpialidocious    ')
	end

	def test_multiple_words
		assert_equal 4, ReadingTime.count_words('This is a test')
		assert_equal 6, ReadingTime.count_words('Four score and seven years ago')
	end

	def test_punctuation
		assert_equal 2, ReadingTime.count_words('Hello, world!')
		assert_equal 2, ReadingTime.count_words('Hello, world !')
		# This module nominally only supports English, but ¿ and é should be handled correctly anyway
		assert_equal 3, ReadingTime.count_words('¿Por qué, Maria?')
	end

	def test_quotes_and_apostrophes
		assert_equal 6, ReadingTime.count_words('"Well, that\'s all right," he said.')
		assert_equal 6, ReadingTime.count_words('“Well, that’s all right,” he said.')
		assert_equal 6, ReadingTime.count_words('\'Twas brillig, and the slithy toves')
		assert_equal 6, ReadingTime.count_words('’Twas brillig, and the slithy toves')
		assert_equal 4, ReadingTime.count_words('The contrived sentences\' apostrophes')
		assert_equal 4, ReadingTime.count_words('The contrived sentences’ apostrophes')
	end

	def test_html_punctuation
		assert_equal 3, ReadingTime.count_words('Well that&rsquo;s annoying')
		assert_equal 5, ReadingTime.count_words('These&#x20;really&#x20;are&#x20;separate&#x20;words')
		assert_equal 3, ReadingTime.count_words('&#x4e;&#101;&#x76;&#101;&#x72;&#x20;&#x64;&#111;&#x20;&#x74;&#x68;&#105;&#115;&#33;')
	end

	def test_html_tags
		assert_equal 4, ReadingTime.count_words('Ends with a <strong>tag</strong>')
		assert_equal 4, ReadingTime.count_words('<em>Starts</em> with a tag')
		assert_equal 4, ReadingTime.count_words('This statement is <!-- not --> false')
		assert_equal 1, ReadingTime.count_words('<abbr title="Don\'t count these words">DCTW</abbr>!')
		assert_equal 1, ReadingTime.count_words('<a href="http://words" title="more words">Cool</a>')
		assert_equal 45, ReadingTime.count_words('<p>—Ladies and Gentlemen,</p>

		<p>—A new generation is growing up in our midst, a generation actuated by new ideas and new
		principles. It is serious and enthusiastic for these new ideas and its enthusiasm, even when
		it is misdirected, is, I believe, in the main sincere.</p>')
	end
end

class ReadingTimeTest < Minitest::Test
	def test_shorter_than_one_minute
		assert_equal 0, ReadingTime.reading_time('')
		assert_equal 1, ReadingTime.reading_time('a')
		assert_equal 1, ReadingTime.reading_time('This is a test')
		assert_equal 1, ReadingTime.reading_time('<p>—Ladies and Gentlemen,</p>

		<p>—A new generation is growing up in our midst, a generation actuated by new ideas and new
		principles. It is serious and enthusiastic for these new ideas and its enthusiasm, even when
		it is misdirected, is, I believe, in the main sincere.</p>')
		assert_equal 1, ReadingTime.reading_time('<span class="word">Foo</span>' * 269)
	end

	def test_at_least_one_minute
		assert_equal 1, ReadingTime.reading_time('<span class="word">Foo</span>' * 270)
		assert_equal 2, ReadingTime.reading_time('<span class="word">Foo</span>' * 271)
		assert_equal 2, ReadingTime.reading_time('<span class="word">Foo</span>' * 539)
		assert_equal 2, ReadingTime.reading_time('<span class="word">Foo</span>' * 540)
		assert_equal 3, ReadingTime.reading_time('<span class="word">Foo</span>' * 541)
	end
end

class LiquidIntegrationTest < Minitest::Test
	def test_count_words
		template = Liquid::Template.parse('{{ str | count_words }}')
		assert_equal '0', template.render('str' => '')
		assert_equal '1', template.render('str' => 'Hello')
		assert_equal '3', template.render('str' => '“He’s dead, Jim!”')
	end

	def test_reading_time
		template = Liquid::Template.parse('{{ str | reading_time }}')
		assert_equal '0', template.render('str' => '')
		assert_equal '1', template.render('str' => 'Hello')
		assert_equal '1', template.render('str' => '<span class="word">Foo</span>' * 270)
		assert_equal '2', template.render('str' => '<span class="word">Foo</span>' * 271)
	end
end
