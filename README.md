# reading\_time

A [Liquid](http://www.liquidmarkup.org/) filter that intelligently counts the number of words in a piece of HTML and estimates how long the text will take to read.

## Installation

The easiest way to install this plugin is with RubyGems: `gem install liquid_reading_time`.

If you’re using Jekyll, see the Jekyll [documentation on installing plugins](http://jekyllrb.com/docs/plugins/#installing-a-plugin) for more-detailed installation instructions. This plugin requires Nokogiri, so if you install this one manually you’ll need to make sure that that one is installed too.

# Usage

Two functions are provided:

* reading\_time

  This function gives an estimate of the amount of time it will take to read the input text. The return value is an integer number of minutes. The input should be HTML (i.e. the text should have already been run through your Markdown or Textile filter). For example, you could use it in a `_layout` file like this:

        {% capture time %}{{ content | reading_time }}{% endcapture %}
        <p>This article will take {{ time }} {% if time == '1' %}minute{% else %}minutes{% endif %} to read.</p>

  Even better, using the [pluralize](https://github.com/bdesham/pluralize) filter,

        <p>This article will take {{ content | reading_time | pluralize: "minute" }} to read.</p>

* count\_words

  This function returns the number of words in the input. Like `reading_time`, this function takes HTML as its input.

## Details

These functions try to be smart about counting words. Specifically, words are not counted if they are contained within any of the following HTML elements: area, audio, canvas, code, embed, footer, form, img, map, math, nav, object, pre, script, svg, table, track, and video. My intention here is to prevent words from contributing toward the count if they don’t seem to be part of the running text—contrast this with the simple but inaccurate approach of e.g. Jekyll’s built-in `number_of_words`.

The plugin assumes a reading speed of 270 words per minute. Wikipedia [cites](https://en.wikipedia.org/w/index.php?title=Words_per_minute&oldid=569027766#Reading_and_comprehension) 250–300 words per minute as a typical range, and I found that I could read articles on my website at about 270 words per minute.

## Author

This plugin was created by [Benjamin Esham](https://esham.io).

This project is [hosted on GitHub](https://github.com/bdesham/reading_time). Please feel free to submit pull requests.

## Version history

The version numbers of this project conform to [Semantic Versioning 2.0](http://semver.org/).

* 1.1.3 (2017-07-19)
  - Updated the dependencies to reflect that the plugin works with Liquid 4 (without any code changes needed).
* 1.1.2 (2015-03-07)
  - Apostrophes and curly single quotes shouldn’t break words into two.
  - This plugin works with Liquid 3.x in addition to 2.x; updated the dependencies to reflect that.
  - Added unit tests.
* 1.1.1 (2015-03-04)
  - Don’t put the `ReadingTime` module in the `Jekyll` module.
  - Packaged the plugin as a Gem.
* 1.1.0 (2013-08-30)
  - Switched from REXML to Nokogiri for HTML parsing.
  - Input can now be HTML or XHTML. Previously, only valid XML was accepted (so things like non-closed `img` tags would make `reading_time` crash).
  - Character entities like `&#x8617;` are no longer included in the word count.
* 1.0.0 (2013-08-24): Changed reading speed from 220 to 270 words per minute.
* 0.9.0 (2013-08-19): Initial release.

## License

Copyright © 2013, 2015, 2017 Benjamin D. Esham. This program is released under the ISC license, which you can find in the file LICENSE.md.
