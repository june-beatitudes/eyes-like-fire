PANDOC := pandoc

build: src/*.md src/template.html 
	rm -rf build/*
	pandoc -N -s -t chunkedhtml -o build/english.zip src/english.md --shift-heading-level-by=-1 --toc=true --template=src/template.html
	pandoc -N -s -t chunkedhtml -o build/russkij.zip src/russkij.md --shift-heading-level-by=-1 --toc=true --template=src/template.html
	pandoc -N -s -t chunkedhtml -o build/francais.zip src/francais.md --shift-heading-level-by=-1 --toc=true --template=src/template.html
	unzip build/english.zip -d build
	unzip build/francais.zip -d build/francais
	unzip build/russkij.zip -d build/russkij
	rm build/english.zip build/russkij.zip build/francais.zip

deploy: build
	ssh site@hestia-website "rm -rf ~/build"
	scp -r build site@hestia-website:~

