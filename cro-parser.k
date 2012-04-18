in cro-config
in cro-common
in cro-syntax

module CRO-PARSER imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG

	kvar P			: K
	kvar S			: #String
	kvar I I1 I2		: #Id
	kvar T			: Type
	kvar Is			: Ids
	kvar Es			: Exps
	kvar Cs			: Cmds
	kvar B			: Block
	kvar Rho		: Map

	syntax K ::= "parse" "(" K ")" | "parseOk"
	rule
		<k> parse(P) => P ~> parseOk ... </k>
		<error> _ => "Unknown parser error." </error>

	rule
		<k> parseOk => . ... </k>
		<error> _ => "" </error>

	syntax K ::= "parserError" "(" #String ")" | "PARSE-ERROR"
	rule
		<k> parserError(S) => PARSE-ERROR ... </k>
		<error> _ => S </error>

	syntax Module		::= "module" "(" Map ")"
	syntax Class		::= "class"  "(" Ids "," Type "," Map ")" // TODO: This should be reworked into a lambda abstraction...
	syntax Method		::= "method" "(" Ids"," Type "," Block ")"
	syntax Object		::= "objectNew" "(" #Id "," Ids ")" | "objectInstance" "(" Map ")"
	syntax Program		::= Module | Class | Method | Object
	syntax ProgramStack	::= List{Program, ","}

	kvar Ps		: ProgramStack
	kvar M		: Method
	kvar C		: Class

	// Anything that is illegal independent of context should be placed here.
	rule	<k> (. => parserError("Empty module declaration not allowed.")) (module I { }) ... </k>
	rule	<k> (. => parserError("Empty class declaration not allowed.")) (class I(Es) { }) ... </k>

	//@ Parse and check the grammar of a module (should only allow class declarations).
	syntax K ::= "closeModule" "(" #Id ")"
	rule
		<k> module I { Cs } => Cs ~> closeModule(I) ... </k>
		<parseStack> _ => module(.Map),.ProgramStack </parseStack>

	//@ Close the last module environment on the stack, actually a no-op atm.
	rule
		<k> closeModule(I) => . ... </k>

	//@ We found a class declaration, create a new class environment on the parseStack.
	syntax K ::= "closeClass" "(" #Id ")"
	rule
		<k> class I ( Es ) { Cs } => Cs ~> closeClass(I) ... </k>
		<parseStack> Ps => class(ids(Es), from types(Es) to object, .Map),Ps </parseStack>

	//@ \texttt{new} is only allowed in class declarations (add a binding for it).
	rule
		<k> I1 = new I2(Es); => . ... </k>
		<parseStack> class(Is, T, Rho),Ps => class(Is, T, Rho I1 |-> objectNew(I2, Es)),Ps </parseStack>
		when notBool(I1 in keys(Rho))

	//@ Close the last class environment on the parseStack.
	rule
		<k> closeClass(I) => . ... </k>
		<parseStack> C,module(Rho),Ps => module(Rho I |-> C),Ps </k>
		when notBool(I in keys(Rho))

	//@ Close the last method environment on the parseStack.
	syntax K ::= "closeMethod" "(" #Id ")"
	rule
		<k> method I ( Es ) : T B => closeMethod(I) ... </k>
		<parseStack> Ps => (method(ids(Es), from types(Es) to T, B),Ps) </parseStack>
	rule
		<k> closeMethod(I) => . ... </k>
		<parseStack> M,class(Is, T, Rho),Ps => class(Is, T, Rho I |-> M),Ps </parseStack>
		when notBool(I in keys(Rho))


end module