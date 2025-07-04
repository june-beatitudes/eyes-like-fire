PANDOC := pandoc

build: src/*.md
	rm -rf build/*
	pandoc -N -s -t chunkedhtml -o build/pages.zip $< --shift-heading-level-by=-1 --toc=true
	unzip build/pages.zip -d build
	rm build/pages.zip

deploy: build
	ssh site@website "rm -rf ~/build"
	scp -r build site@website:~

