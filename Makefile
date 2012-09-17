all: Makefile cro-core-compiled.maude

pdf: cro-core.pdf

cro-core-compiled.maude: cro-core*.k
	notify-completion.sh "kompile cro-core"

cro-core.pdf: cro-core*.k
	notify-completion.sh "kompile --pdf cro-core"

cro.pdf: cro.k cro-*.k
	notify-completion.sh "kompile --pdf cro"

test: cro-core-compiled.maude
	krun programs/test.cro

test2: cro-core-compiled.maude
	krun programs/test2.cro

test3: cro--core-compiled.maude
	krun programs/test3.cro

ast: cro-core-compiled.maude
	kast programs/test.cro && echo
#kast --k-definition ./cro --main-module CRO --syntax-module CRO-SYNTAX programs/test.cro && echo

clean:
	touch *.k
