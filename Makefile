all: cro-compiled.maude

pdf: cro.pdf

cro-compiled.maude: cro.k cro-*.k
	kompile cro

cro.pdf: cro.k cro-*.k
	kompile --pdf cro

test: cro-compiled.maude
	krun programs/test.cro

test2: cro-compiled.maude
	krun programs/test2.cro

test3: cro-compiled.maude
	krun programs/test3.cro

ast: cro-compiled.maude
	kast programs/test.cro && echo
#kast --k-definition ./cro --main-module CRO --syntax-module CRO-SYNTAX programs/test.cro && echo

clean:
	touch cro.k
