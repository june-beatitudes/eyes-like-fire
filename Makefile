PANDOC := pandoc
PANDOC_OPTS := -N -s -fmarkdown -tchunkedhtml --shift-heading-level-by=-1 --toc=true --template=src/template.html --lua-filter=extern/include-files/include-files.lua

build: src/*.md src/*.tex src/template.html 
	rm -rf build/*
	latex -output-directory=build -output-format=dvi src/projects-chart.tex
	dvisvgm build/projects-chart.dvi -o src/projects-chart.svg -n
	pandoc -o build/english.zip src/english.md $(PANDOC_OPTS)
	pandoc -o build/francais.zip src/francais.md $(PANDOC_OPTS)
	pandoc -o build/russkij.zip src/russkij.md $(PANDOC_OPTS)
	unzip build/english.zip -d build
	unzip build/francais.zip -d build/francais
	unzip build/russkij.zip -d build/russkij
	rm build/english.zip build/russkij.zip build/francais.zip
	rm build/projects-chart.dvi build/projects-chart.aux build/projects-chart.log

deploy: build
	ssh site@hestia-website "rm -rf ~/build"
	scp -r build site@hestia-website:~

