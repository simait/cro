// in cro-syntax

module CRO-SYNTAX

// 	// "root" and "init" are a part of all programs (for now...)
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

// 	// Type info of expressions...
	syntax Exp ::= Exp ":" Type					[prec 40]

	// Variable declarations, ugly due to the modest parsing abilities of K.
// 	syntax Decl ::= Type ";"					[prec 100]
// 	syntax Type ::=
// 		"int" #Id						[prec 100]
// 		| "int" #Id "[" #Int "]"				[prec 100]

	syntax Type ::=
		"void"
		| "int"
		| "bool"
		| "object"
		| "int" "[" #Int "]"					[prec 100]
		| "class" "from" Types "to" Type			[prec 100]
		| "method" "from" Types "to" Type			[prec 100]
	syntax Types ::= List{Type, ","}				[prec 100]

	syntax Decl ::= #Id ":" Type ";"				[prec 102]

	syntax Cmd ::=
		Exp ":=" Exp ";"					[prec 101]
		| "return" ";"						[prec 101]
		| "return" Exp ";"					[prec 101]
		| "if" "(" Exp ")" Block				[prec 103 gather (e E)]
		| "if" "(" Exp ")" Block "else" Block			[prec 103 gather (e E E)]
		| "foreach" #Id "in" #Id Block				[prec 103 gather (e e E)]

	// Desugar if-cmds
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

module CRO

	imports CRO-SYNTAX

	configuration
		<T>
			<k> $PGM:K</k>
			<env> .Map </env>
			<memory> .Map </memory>
			<location>0</location>
// 			<messages>
// 				<message multiplicity="*">
// 				</message>
// 			</messages>
			<classes>
				<class multiplicity="*">
					<name>"main"</name>
					<type>.K</type>
					<params>.K</params>
					<bindings>.K</bindings>
				</class>
			</classes>
// 			<methods>
// 				<method multiplicity="*">
// 					<name>"main"</name>
// 					<type>.K</type>
// 					<params>.K</params>
// 					<body>.K</body>
// 				</method>
// 			</methods>
// 			<mstack> .List </mstack>
		</T>

	syntax Ids ::= List{#Id, ","}

	kvar N			: #Int
	kvar I CN		: #Id
	kvar Is			: Ids
	kvar E			: Exp
	kvar Es			: Exps
	kvar T R		: Type
	kvar B			: Block
	kvar Cs C1 C2		: Cmds
	kvar D			: Decl
	kvar Ds			: Decls
	kvar M			: Map

	declare types : Exps -> Types
	define types(.Exps)		=> void,.Types
	define types(I : T, .Exps)	=> T,.Types
	define types(I : T, E, Es)	=> T, types(E, Es)

	declare ids : Exps -> Ids
	define ids(.Exps)		=> .Ids
	define ids(I : T, .Exps)	=> I, .Ids
	define ids(I : T, E, Es)	=> I, ids(E, Es)
	
	syntax Decls ::= List{Decl, ","}
	syntax K ::= "methodDecl" "(" Type "," Ids "," Block ")"
// 	syntax K ::= "classDecls" "(" Decls ")"
// 	rule
// 		<k> classDecls(.Decls) => .Map ... </k>
// 	rule
// 		<k> classDecls((method I (Es) : R B), .Decls)	=> I |-> methodDecl(method from types(Es) to R, ids(Es), B) ... </k>
// 	rule
// 		<k> classDecls((method I ( Es ) : R B), D, Ds) 	=> I |-> methodDecl(method from types(Es) to R, ids(Es), B) classDecls(D,Ds)

// 	context classDecls(HOLE)
	
// 	declare classDecls : Decls -> Map
// 	define classDecls(.Decls)				=> .Map
// 	define classDecls((method I ( Es ) : R B), .Decls)	=> I |-> methodDecl(method from types(Es) to R, ids(Es), B)
// 	define classDecls((method I ( Es ) : R B), D, Ds) 	=> I |-> methodDecl(method from types(Es) to R, ids(Es), B) classDecls(D,Ds)

	syntax K ::= "lookup" "(" #Int ")"
// 	rule
// 		<k> lookup ( N ) => V ... </k>
// 		<memory> ... N |-> V ... </memory>

	syntax K ::= "execute"
// 	rule <k> execute => new root(); </k>

// -----------------------------------------------------------------------------

	syntax K ::= "classBindings" "(" #Id "," Cmds ")"
	rule
		<k> classBindings(CN, method I ( Es ) : R B) => . ... </k>
		<name> CN </name>
		<bindings> (. => I |-> methodDecl(method from types (Es) to R, ids(Es), B)) ... </bindings>

	rule
		<k> classBindings(CN, ((method I ( Es ) : R B) Cs)) => classBindings(CN, Cs) ... </k>
		<name> CN </name>
		<bindings> (. => I |-> methodDecl(method from types (Es) to R, ids(Es), B)) ... </bindings>

	syntax K ::= "createClass" "(" #Id "," Type "," Ids ")"
	rule
		<k> createClass(CN, T, Is) => . ... </k>
		<classes>...
			( . => <class>
				<name> CN </name>
				<type> T </type>
				<params> Is </params>
				<bindings> .Map </bindings>
			</class>)
		</classes>

	rule
		<k> module I { Cs } => Cs ... </k>

	rule
		<k> class I ( Es ) { } => createClass(I, class from types(Es) to object, ids(Es)) ... </k>
	rule
		<k> class I ( Es ) { Cs } => createClass(I, class from types(Es) to object, ids(Es)) ~> classBindings(I, Cs) ... </k>
	
	rule
		C1 C2 => C1 ~> C2					[structural]

end module