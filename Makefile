PANDOC := pandoc

build: src/*.md
	pandoc -s -t chunkedhtml -o build/pages.zip $< --shift-heading-level-by=-1 --toc=true
	unzip build/pages.zip -d build
	rm build/pages.zip

clean:
	rm -rf build/*
