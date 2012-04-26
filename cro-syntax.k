module CRO-SYNTAX

	// "root" and "init" are a part of all programs (for now...)
	syntax Id ::= "root" | "init"

	// Expressions, still needs work to get precedence "right".
	syntax Exp ::=
		Val
		| Id
		| Exp "." Id						[prec(1) strict(2)]
		| Exp "(" Exps ")"					[prec(2) strict]
		| "(" Exp ")"

		| Exp ":" Type						[prec(10)]

		| "-" Exp						[prec(50)]

		| Exp "*" Exp						[prec(52) strict gather (E e)]
		| Exp "/" Exp						[prec(52) strict gather (E e)]
		| Exp "%" Exp						[prec(52) strict gather (E e)]

		| Exp "+" Exp						[prec(53) strict gather (E e)]
		| Exp "-" Exp						[prec(53) strict gather (E e)]

		| Exp "<" Exp						[prec(53) strict]
		| Exp "<=" Exp						[prec(53) strict]
		| Exp ">" Exp						[prec(53) strict]
		| Exp ">=" Exp						[prec(53) strict]
		| Exp "!=" Exp						[prec(53) strict]
		| Exp "==" Exp						[prec(53) strict]

		| "not" Exp						[prec(54) strict]
		| Exp "and" Exp						[prec(55) strict]
		| Exp "or" Exp						[prec(56) strict]

	syntax Exps ::= List{Exp, ","}					[strict]

	// Variable declarations, ugly due to the modest parsing abilities of K.
	syntax Type ::=
		"void"
		| "int"
		| "bool"
		| "string"
		| "object"
		| "int" "[" Int "]"
		| "from" Types "to" Type				[latex("{1}~\rightarrow~{2}")]
	syntax Types ::= List{Type, ","}

	syntax Stmt ::=
		"{" "}"
		| "{" Stmts "}"
		| Exp ";"						[prec(45) strict]
		| Exp ":=" Exp ";"					[prec(91) /*strict 2 gather (e E)*/]
		| "return" ";"
		| "return" Exp ";"					[prec(90) strict]
		| "if" "(" Exp ")" Stmt "else" Stmt			[prec(90) strict(1)]
		| "if" "(" Exp ")" Stmt					[prec(89)]
		| "send" Exp ";"					[prec(90)]
		| "read" "(" ")" ";"					[prec(90)]
		| "print" "(" Exps ")" ";"				[prec(90) strict]
		| "halt" ";"

	syntax Stmts ::=
		Decl
		| Stmt
		| Stmts Stmts						[prec 100 gather (e E)]

	syntax Decl ::= "method" Id "(" Exps ")" ":" Type Stmt
	syntax Decl ::= "var" Exp ":=" Val ";"
	syntax Decl ::= Id "=" "new" Exp "(" Exps ")" ";"

	syntax Decl ::= "class" Id "(" Exps ")" Stmt

	syntax Val ::=
		Int
		| Bool
		| String
	syntax Vals ::= List{Val, ","}

	//Module definition, should be top level but no way to enforce this?
	syntax Module ::= "module" Id Stmt

	kvar I			: Id
	kvar T			: Type
	kvar B			: Stmt
	kvar E E1 E2		: Exp
	kvar Es			: Exps

	// Add a false branch - ease of parsing.
	macro if (E) B = if ( E ) B else { }

	// Remove any "empty" return.
	syntax Val ::= "nothing"
	macro return ; = return nothing ;
	macro method I(Es) : T { } = method I(Es) : T {return nothing;}

	// Expand variable declaration list - ease of parsing.
// 	macro var E1,E2,Es; = var E1; var E2,Es;

end module