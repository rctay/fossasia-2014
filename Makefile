# reveal.js slides
patchy.html: patchy.md
	pandoc -t revealjs -s -o $@ $^

# markdown handouts
patchy_md.html: patchy.md
	pandoc -t html5 -s -o $@ $^
