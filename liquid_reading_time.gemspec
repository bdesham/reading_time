Gem::Specification.new do |s|
	s.name				= 'liquid_reading_time'
	s.version			= '1.1.3'
	s.date				= '2017-07-19'

	s.author			= 'Benjamin Esham'
	s.email				= 'benjamin@esham.io'
	s.homepage		= 'https://github.com/bdesham/reading_time'
	s.license			= 'MIT'

	s.summary			= 'A Liquid filter to count words and estimate reading times.'
	s.description	= 'A Liquid filter that intelligently counts the number of words in a piece of HTML and estimates how long the text will take to read.'

	s.files				= ['lib/liquid_reading_time.rb']

	s.add_runtime_dependency('liquid', ['>= 2.6', '< 5.0'])
	s.add_runtime_dependency('nokogiri', '~> 1.6')
end
