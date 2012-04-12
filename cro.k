// in cro-syntax

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

	

	// Variable declarations, ugly due to the modest parsing abilities of K.
	syntax Decl ::= Type ";"					[prec 100]
	syntax Type ::=
		"int" #Id						[prec 100]
		| "int" #Id "[" #Int "]"				[prec 100]

	syntax Decl ::= "method" #Id "(" ParamList ")" Block		[prec 102]

	syntax Cmd ::=
		Exp ":=" Exp ";"					[prec 101]
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

	syntax ParamList ::= List{Type, ","}				[prec 100]

	syntax Decl ::=
		"class" #Id "(" ParamList ")" Block			[prec 100]

	//Module definition, should be top level but no way to enforce this?
	syntax Module ::= "module" #Id Block				[prec 120]

end module

module CRO

	imports CRO-SYNTAX

	syntax Val ::=
		#Int
		| #Bool

	syntax KResult ::= Val

	configuration
		<T>
			<k> $PGM:K ~> execute </k>
			<env> .Map </env>
			<memory> .Map </memory>
			<location>0</location>
			<mstack> .List </mstack>
			<classes>
				<class multiplicity="*">
 					<name>"root"</name>
					<params>.K</params>
					<declarations>.Map</declarations>
				</class>
			</classes>
		</T>

	kvar V		: Val
	kvar L		: #Int
	kvar I I1 I2	: #Id
	kvar Ps Ps1 Ps2	: ParamList
	kvar Es		: Exps
	kvar Cs C1 C2	: Cmds
	kvar B B1 B2	: Block
	kvar Env	: Map
	kvar K		: K

	rule
		<k> module I { Cs } => Cs ... </k>				[structural]

	rule
		<k> class I ( Ps ) { Cs } => Cs ... </k>			[structural]

	syntax K ::= "closure" "(" ParamList "," Block ")"
	rule
		<k> method I ( Ps ) B => . ... </k>
		<location> L => L +Int 1 </location>
		<env> . => I |-> L ... </env>
		<memory> . => L |-> closure( Ps, B ) ... </memory>

	rule
		<k> new I(); => Cs ... </k>
		<name> I </name>
		<params> Ps </params>
		<declarations> Cs </declarations>

	rule
		C1 C2 => C1 ~> C2					[structural]

	syntax K ::= "lookup" "(" #Int ")"
	rule
		<k> lookup ( L ) => V ... </k>
		<memory> ... L |-> V ... </memory>

	syntax K ::= "execute"
	rule <k> execute => new root(); </k>
	
end module