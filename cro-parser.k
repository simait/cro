in cro-config
in cro-common
in cro-syntax

module CRO-PARSER imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG

	// This can probably be simplified (see the Core module of the Timber compiler...).
	syntax Module		::= "module" "(" Map ")"
// 	syntax Bind		::= "bind" "(" Id "," Type "," Cmds ")"
	syntax Class		::= "class"  "(" Ids "," Type "," Map ")"
	syntax Method		::= "method" "(" Ids "," Type "," Map "," Cmds ")"
	syntax Object		::= "class" "(" Id "," Ids ")" | "objectInstance" "(" Map ")"
	syntax Cmd		::=
					"cass" Exp Exp
					| "cbind" Exp Cmds
					| "cret" Exp
	syntax Cmds 		::= List{Cmd, ","}
	syntax Program		::= Module | Class | Method | Object
	syntax ProgramStack	::= List{Program, ","}

	syntax Val		::= "typedVal" "(" Val "," Type")"

	syntax ListItem		::= "(" Id "," Map "," K ")"

	kvar P			: K
	kvar Str		: String
	kvar I I1 I2		: Id
	kvar T T1 T2		: Type
	kvar Is			: Ids
	kvar E E1 E2		: Exp
	kvar Es			: Exps
	kvar S			: Stmt
	kvar D			: Decl
	kvar Ss			: Stmts
	kvar Rho		: Map
	kvar Ps			: ProgramStack
	kvar M			: Method
	kvar Cls		: Class
	kvar C			: Cmd
	kvar Cs			: Cmds
	kvar V			: Val

// 	declare reverseStmts : Stmts -> Stmts
	syntax ReverseStmts ::= "reverseStmts" "(" Stmts ")"			[function klabel(reverseStmts)]
	define reverseStmts((D Ss))	=> reverseStmts(Ss) D
	define reverseStmts((S Ss))	=> reverseStmts(Ss) S
	define reverseStmts(D)		=> D
	define reverseStmts(S)		=> S

	syntax K ::= "parse" "(" K ")" | "parseOk"
	rule
		<k> parse(P) => P ~> parseOk ... </k>
		<error> _ => "Unknown parser error." </error>

	rule
		<k> parseOk => . ... </k>
		<error> _ => "" </error>
		<parseStack> P => . </parseStack>
		<program> . => P </program>

	syntax K ::= "parserError" "(" String ")" | "PARSE-ERROR"
	rule
		<k> parserError(Str) => PARSE-ERROR ... </k>
		<error> _ => Str </error>

	// Anything that is illegal independent of context should be placed here.
// 	rule	<k> (. => parserError("Empty module declaration not allowed.")) (module I { }) ... </k>
// 	rule	<k> (. => parserError("Empty class declaration not allowed.")) (class I(Es) { }) ... </k>

	//@ Parse and check the grammar of a module (should only allow class declarations).
// 	syntax K ::= "closeModule" "(" Id ")"
// 	rule
// 		<k> module I { Ss } => Ss ~> closeModule(I) ... </k>
// 		<parseStack> _ => module(.Map),.ProgramStack </parseStack>
// 
// 	//@ Close the last module environment on the stack, actually a no-op atm.
// 	rule
// 		<k> closeModule(I) => . ... </k>
// 
// 	//@ We found a class declaration, create a new class environment on the parseStack.
// 	syntax K ::= "closeClass" "(" Id ")"
// 	rule
// 		<k> class I ( Es ) { Ss } => Ss ~> closeClass(I) ... </k>
// 		<parseStack> Ps => class(ids(Es), from types(Es) to object, .Map), Ps </parseStack>
// 
// 	//@ \texttt{new} is only allowed in class declarations (add a binding for it).
// 	rule
// 		<k> I1 = new I2(Es); => . ... </k>
// 		<parseStack> class(Is, T, Rho => Rho I1 |-> class(I2 ,Es)), Ps </parseStack>
// 		when notBool(I1 in keys(Rho))
// 
// 	rule
// 		<k> var I : T1 := V; => . ... </k>
// // 		<parseStack> C,Ps </parseStack>
// 		<parseStack> class(Is, T2, Rho => Rho I |-> typedVal(V, T1)), Ps </parseStack>
// 		when notBool(I in keys(Rho))
// 
// 	//@ Close the last class environment on the parseStack.
// 	rule
// 		<k> closeClass(I) => . ... </k>
// 		<parseStack> Cls, module(Rho), Ps => module(Rho I |-> Cls), Ps </k>
// 		when notBool(I in keys(Rho))
// 
// 	//@ Close the last method environment on the parseStack.
// 	syntax K ::= "closeMethod" "(" Id ")"
// 	rule
// 		<k> method I ( Es ) : T { } => closeMethod(I) ... </k>
// 		<parseStack> Ps => (method(ids(Es), from types(Es) to T, .Map, .Cmds), Ps) </parseStack>
// 	rule
// 		<k> method I ( Es ) : T { Ss } => reverseStmts(Ss) ~> closeMethod(I) ... </k>
// 		<parseStack> Ps => (method(ids(Es), from types(Es) to T, .Map, .Cmds), Ps) </parseStack>
// 	rule
// 		<k> return E; => . ... </k>
// 		<parseStack> method(Is, T, Rho, Cs => cret E, Cs), Ps </parseStack>
// 	rule
// 		<k> var I : T1 := V; => . ... </k>
// 		<parseStack> method(Is, T2, Rho => Rho I |-> typedVal(V, T1) , Cs), Ps </parseStack>
// 		when notBool(I in keys(Rho))
// 	rule
// 		<k> E1 := E2 ; => . ... </k>
// 		<parseStack> method(Is, T, Rho, Cs => (cass E1 E2), Cs), Ps </parseStack>
// 	rule
// 		<k> closeMethod(I) => . ... </k>
// 		<parseStack> M,class(Is, T, Rho),Ps => class(Is, T, Rho I |-> M),Ps </parseStack>
// 		when notBool(I in keys(Rho))

end module