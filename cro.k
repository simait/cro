// in cro-syntax

module CRO-SYNTAX

	// Variable declarations, ugly due to the modest parsing abilities of K.
	syntax Decl ::= Type ";"
	syntax Type ::=
		"int" #Id
		| "int" #Id "[" #Int "]"

	// Method declarations.
	syntax Decl ::= "method" #Id "(" ParamList ")" Block			[prec(10)]
	syntax Block ::=
		"{" "}"
		| "{" Cmds "}"
	syntax Cmd ::=
		Exp ":=" Exp ";"						[prec(100)]
		| "if" "(" Exp ")" Block					[prec(101)]
		| "if" "(" Exp ")" Block "else" Block				[prec(102)]
		| "foreach" #Id "in" #Id Block					[prec(102)]
	syntax Cmds ::=
		Decl
		| Cmd
		| Cmds Cmds							[prec(120)]
 	syntax ParamList ::= List{Type, ","}					[prec(121)]
	
	// Expressions, still needs work to get precedence "right".
	syntax Exp ::=
		#Int
		| #Id
// 		| "(" Exp ")"						/*[strict]*/
// 
// 		| Exp "." Exp						[prec(50) gather(E e)]
// 
// 		| "-" Exp						/*[strict]*/
// 
// 		| Exp "*" Exp						[prec(51) gather(E e)]
// 		| Exp "/" Exp						[prec(51) gather(E e)]
// 		| Exp "%" Exp						[prec(51) gather(E e)]
// 
		| Exp "+" Exp						[prec(52) gather(E e)]
// 		| Exp "-" Exp						[prec(52) gather(E e)]
// 
// 		| Exp "<" Exp						[prec(53)]
// 		| Exp "<=" Exp						[prec(53)]
// 		| Exp ">" Exp						[prec(53)]
// 		| Exp ">=" Exp						[prec(53)]
// 		| Exp "!=" Exp						[prec(53)]
// 		| Exp "==" Exp						[prec(53)]
// 
// 		| "not" Exp						[prec(54)]
// 
// 		| Exp "and" Exp						[prec(55)]
// 		| Exp "or" Exp						[prec(56)]

	// List of expressions, used when invoking methods.
	syntax Exps ::= List{Exp, ","}

	syntax Decl ::=
		"class" #Id "(" ParamList ")" Block			[prec(120) gather(E E E)]

	// Module definition, should be top level but no way to enforce t	his.
	syntax Module ::= "module" #Id Block

	// Desugar if-cmds
// 	macro if (E:Exp) T:Block = if (E) T else { }

end module

module CRO

	imports CRO-SYNTAX

	syntax KResult ::= #Int

	syntax K ::= "init"
	syntax K ::= "execute"

	configuration
		<T>
			<k> $PGM:K ~> init ~> execute </k>
			<classes>
				<class multiplicity="*">
 					<name>"root"</name>
					<declarations>.K</declarations>
				</class>
			</classes>
		</T>

	kvar I        : #Id
	kvar Ps       : ParamList
	kvar C        : Cmd
	kvar Cs C1 C2 : Cmds
	kvar B        : Block

	rule
		<k> module I { B } => B ...</k>				[structural]

	rule
		<k> class I ( Ps ) { B } => . ... </k>
		<classes>
			. => (<class>
				<name> I </name>
				<declarations> B </declarations>
			</class>) ...
		</classes>

	rule
		C1 C2 => C1 ~> C2					[structural]

end module