in cro-common
in cro-syntax
in cro-config
in cro-parser
in cro-semantic

module CRO imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG + CRO-PARSER + CRO-SEMANTIC

	kvar S1 S2		: Stmts
	kvar P			: K

	// Ensure sequential execution of commands.
	rule	S1 S2 => S1 ~> S2														[structural]

	//@ First rule, the loded program is in the <k> cell, we "lift" it and start the process of parsing and validating.
	rule
		<k> loadedProgram(P) => parseProgram(P) ~> initProgram ~> executeProgram </k>

end module