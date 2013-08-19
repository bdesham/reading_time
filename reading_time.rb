require 'rexml/document'

module Jekyll
	module ReadingTime

		def count_words(html)
			words(html).map { |text| text.length }.reduce(:+)
		end

		def reading_time(html)
			(count_words(html) / 220.0).ceil
		end

		private

		def text_nodes(root)
			ignored_tags = %w[ area audio canvas code embed footer form img map math nav object pre script svg table track video ]
			texts = []
			root.each_element { |el|
				unless ignored_tags.include? el.name
					texts.concat el.texts
					texts.concat text_nodes(el)
				end
			}
			texts
		end

		def words(html)
			root = REXML::Document.new("<root>#{html}</root>").root
			text_nodes(root).flatten.map { |text| text.to_s.scan(/[[:word:]]+/) }
		end

	end
end

Liquid::Template.register_filter(Jekyll::ReadingTime)
