module CRO-SYNTAX
	syntax Exp ::=
		#Int
		| #Id
		| Exp "." #Id		[strict]
		| "(" Exp ")"		[strict]
		| Exp "+" Exp		[strict]
		| Exp "-" Exp		[strict]
		| Exp "*" Exp		[strict]
		| Exp "/" Exp		[strict]
// 		| Exp "<" Exp		[strict]
// 		| Exp "<=" Exp		[strict]
// 		| Exp ">" Exp		[strict]
// 		| Exp ">=" Exp		[strict]
// 		| Exp "!=" Exp		[strict]

	syntax Cmd ::=
		Exp ":=" Exp ";"
		| Cmd Cmd

	syntax Pgm ::= Cmd
end module