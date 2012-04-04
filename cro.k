// in cro-syntax

module CRO-SYNTAX

	syntax Decl ::=
		"int" #Id

	syntax State ::=
		Decl ";"
		| State State						[gather(E e)]

	syntax Method ::=
		"method" #Id "(" List{Decl, ","} ")"/* "{" Cmd "}"*/
// 		| Method Method						[gather(E e)]

	syntax Module ::=
		"module" #Id "{" Object "}"

	syntax Object ::=
		"object" #Id "{" ObjectBody "}"
		| Object Object						[gather(E e)]

	syntax ObjectBody ::=
		State
		| Method
		| State Method						[gather(E e)]

	syntax Exp ::=
		#Int
		| #Id
		| Exp "." #Id						[strict]
// 		| "(" Exp ")"						[strict]
		| Exp "+" Exp						[strict]
		| Exp "-" Exp						[strict]
		| Exp "*" Exp						[strict]
		| Exp "/" Exp						[strict]
		| Exp "<" Exp						[strict]
		| Exp "<=" Exp						[strict]
		| Exp ">" Exp						[strict]
		| Exp ">=" Exp						[strict]
		| Exp "!=" Exp						[strict]

	syntax Cmd ::=
		Exp ":=" Exp ";"
		| Cmd Cmd						[gather(E e)]

	syntax Pgm ::= Module

end module

module CRO

	syntax KResult ::= #Int

	configuration
		<T>
			<k> $PGM:K </k>
		</T>

end module