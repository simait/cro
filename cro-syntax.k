module CRO-SYNTAX

	// "root" and "init" are a part of all programs (for now...)
	syntax #Id ::= "root" | "init"

	// Expressions, still needs work to get precedence "right".
	syntax Exp ::=
		#Int							[prec 0]
		| #Bool							[prec 0]
		| #Id							[prec 0]
		| "new" #Id "(" Exps ")"				[prec 50]
		| Exp "." Exp						[prec 50 gather (E e)]

		| Exp "(" Exps ")"					[prec 51 gather (e E)]
		| "(" Exp ")"

		| "-" Exp						[prec 50]

		| Exp "*" Exp						[prec 52 gather (E e)]
		| Exp "/" Exp						[prec 52 gather (E e)]
		| Exp "%" Exp						[prec 52 gather (E e)]

		| Exp "+" Exp						[prec 53 gather (E e)]
		| Exp "-" Exp						[prec 53 gather (E e)]

		| Exp "<" Exp						[prec 53]
		| Exp "<=" Exp						[prec 53]
		| Exp ">" Exp						[prec 53]
		| Exp ">=" Exp						[prec 53]
		| Exp "!=" Exp						[prec 53]
		| Exp "==" Exp						[prec 53]

		| "not" Exp						[prec 54]
		| Exp "and" Exp						[prec 55]
		| Exp "or" Exp						[prec 56]

	syntax Exps ::= List{Exp, ","}					[prec 50]

	// Type info of expressions...
	syntax Exp ::= Exp ":" Type					[prec 40]

	// Variable declarations, ugly due to the modest parsing abilities of K.
	syntax Type ::=
		"void"
		| "int"
		| "bool"
		| "object"
		| "int" "[" #Int "]"					[prec 100]
		| "from" Types "to" Type				[prec 100 latex("{#1}~\rightarrow~{#2}")]
// 		| "from" Types "to" Type			[prec 100 latex("method~({#1})~\rightarrow~{#2}")]
	syntax Types ::= List{Type, ","}				[prec 100]

	syntax Decl ::= #Id ":" Type ";"				[prec 102]

	syntax Cmd ::=
		Exp ":=" Exp ";"					[prec 101]
		| Exp "=" "new" Exp "(" Exps ")" ";"			[prec 101]
		| Exp "(" Exps ")" ";"					[prec 101]
		| "return" ";"						[prec 101]
		| "return" Exp ";"					[prec 101]
		| "if" "(" Exp ")" Block				[prec 103 gather (e E)]
		| "if" "(" Exp ")" Block "else" Block			[prec 103 gather (e E E)]
		| "foreach" #Id "in" #Id Block				[prec 103 gather (e e E)]

	macro if (E:Exp) T:Block = if ( E ) T else { }

	syntax Cmds ::=
		Decl
		| Cmd
		| Cmds Cmds						[prec 105 gather (e E)]

	syntax Block ::=
		"{" "}"							[prec 100]
		| "{" Cmds "}"						[prec 100]

	syntax Decl ::= "method" #Id "(" Exps ")" ":" Type Block	[prec 102]

	syntax Decl ::= "class" #Id "(" Exps ")" Block			[prec 100]

	//Module definition, should be top level but no way to enforce this?
	syntax Module ::= "module" #Id Block				[prec 120]

end module