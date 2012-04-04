module CRO-SYNTAX

	syntax State ::=
		"int" #Id ";"
		| State State

	syntax Method ::=
		"method" #Id "(" List{Exp, ","} ")" "{" Cmd "}"
		| Method Method

	syntax Module ::=
		"module" #Id "{" Object "}"

	syntax Object ::=
		 "object" #Id "{" "}"
// 		"object" #Id "{" "}"
// 		| "object" #Id "{" State "}"
// 		| "object" #Id "{" Method "}"
// 		| Object Object

	syntax Exp ::=
		#Int
		| #Id
		| Exp "!" #Id		[strict]
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
		
		| Exp ":=" Exp ";"
		| Cmd Cmd

end module