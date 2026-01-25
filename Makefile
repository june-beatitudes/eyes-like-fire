PANDOC := pandoc
PANDOC_OPTS := -N -s -fmarkdown -tchunkedhtml --shift-heading-level-by=-1 --toc=true --template=src/template.html -Fmermaid-filter --lua-filter=extern/include-files/include-files.lua

build: src/*.md src/*.tex src/template.html 
	rm -rf build/*
	latex -output-directory=build -output-format=dvi src/projects-chart.tex
	dvisvgm build/projects-chart.dvi -o src/projects-chart.svg -n
	pandoc -o build/english.zip src/english.md $(PANDOC_OPTS)
	pandoc -o build/francais.zip src/francais.md $(PANDOC_OPTS)
	pandoc -o build/blog.zip src/blog.md $(PANDOC_OPTS) --toc-depth=1
	unzip build/english.zip -d build
	unzip build/francais.zip -d build/francais
	unzip build/blog.zip -d build/blog
	rm build/english.zip build/blog.zip build/francais.zip
	rm build/projects-chart.dvi build/projects-chart.aux build/projects-chart.log

deploy: build src/lighttpd.conf
	rsync -r build juniper@hestia:/home/juniper/website
	rsync src/lighttpd.conf juniper@hestia:/home/juniper/website
	rsync src/Dockerfile juniper@hestia:/home/juniper/website
	ssh juniper@hestia "cd website; podman build -t eyes-like-fire:latest .; podman run --network=host -d -v.:/var/www:Z --replace --name website eyes-like-fire:latest"
