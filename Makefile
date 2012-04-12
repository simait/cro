all:
	kompile cro

test:
	krun programs/test.cro

test:
	krun programs/test2.cro

ast:
	kast programs/test.cro && echo
#kast --k-definition ./cro --main-module CRO --syntax-module CRO-SYNTAX programs/test.cro && echo
