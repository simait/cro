in cro-common
in cro-syntax
in cro-config
in cro-parser
in cro-semantic

module CRO imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG + CRO-PARSER + CRO-SEMANTIC

	syntax Val ::=
		#Id
		| #Int

	syntax KResult ::= Val
	
	kvar S1 S2		: Stmts
	kvar P			: K

// -----------------------------------------------------------------------------

// 	syntax K ::= "setTask" "(" #String ")"
// 	rule
// 		<k> setTask(S) => . ... </k>
// 		<currentTask> _ => S </k>
// 
// 	// Namespace (NS) handling.
// 	syntax K ::= "pushNS" "(" #Id ")"
// 	rule
// 		<k> pushNS( I ) => . ... </k>
// 		<parseNS> NS,Is => qId(NS, I),NS,Is </parseNS>
// 
// 	syntax K ::= "popNS" "(" ")"
// 	rule
// 		<k> popNS() => . ... </k>
// 		<parseNS> (I,NS,Is) => (NS,Is) </parseNS>
// 
// 	// Parsing context (PC) handling.
// 	syntax K ::= "pushPC" "(" #String ")"
// 	rule
// 		<k> pushPC( PC ) => . ... </k>
// 		<currentContext> Ss => (PC,Ss) </currentContext>
// 
// 	syntax K ::= "popPC" "(" ")"
// 	rule
// 		<k> popPC() => . ... </k>
// 		<currentContext> PC,Ss => Ss </currentContext>

// -----------------------------------------------------------------------------

	// Ensure sequential execution of commands.
	rule	S1 S2 => S1 ~> S2														[structural]

	//@ First rule, the loded program is in the <k> cell, we "lift" it and start the process of parsing and validating.
	rule
		<k> loadedProgram(P) => P ~> init ~> execute </k>

// 	syntax K ::= "createBinding" "(" #Id "," Type "," K ")"
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<k> createBinding(I, T, Ks) => . ... </k>
// 		<bindings>
// 			...
// 			(. => <binding>
// 				<name> I </name>
// 				<type> T </type>
// 				<body> Ks </body>
// 			</bindings>)
// 		</bindings>

// 	syntax K ::= "lambda" "(" Ids "," Cmds ")"
// 	context lambda(_, HOLE)

	// Parse modules (declared on top-level).
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<k> module I { } ... </k>
// 		<parserError> _ => "Empty module-declaration not allowed." </parserError>
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<k>
// 			module I { Cs } =>
// 			pushNS(I) ~> pushPC("module") ~> Cs ~> popPC() ~> popNS()
// 			...
// 		</k>																[structural]

	// Parse classes (declared on module-level).
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<k> class I ( Es ) { } ... </k>
// 		<parserError> _ => "Empty class-declaration not allowed." </parserError>
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<parseNS> NS,Is </parseNS>
// 		<k>
// 			class I ( Es ) { Cs } =>
// 			pushNS(I) ~> pushPC("class") ~>
// 				createBinding(qId(NS, I), class from types(Es) to object, lambda(ids(Es), Cs)) ~>
// 			popPC() ~> popNS()
// 			...
// 		</k>

	// Parse methods (declared on class-level).
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<k> method I ( Es ) : T { } ... </k>
// 		<parserError> _ => "Empty method-declaration not allowed." </parserError>
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<parseNS> NS,Is </parseNS>
// 		<k>
// 			method I ( Es ) : T { Cs } =>
// 			pushNS(I) ~> pushPC("method") ~> Cs ~> createBinding(qId(NS, I), method from types(Es) to T, lambda(ids(Es), Cs)) ~> popPC() ~> popNS()
// 			...
// 		</k>

	// Restrict creation of objects to class constructors.
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<currentContext> PC </currentContext>
// 		<k> I1 = new I2(Es); => . ...</k>
// 		when PC ==Bool "class"
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<currentContext> PC </currentContext>
// 		<k> (.  => syntaxError("Object creation is only allowed within a class (constructor).")) ~> (I1 = new I2(Es);) ... </k>
// 		when PC =/=Bool "class"

	// Restrict restrict method invocation to methods.
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<currentContext> "method" </currentContext>
// 		<k> (I1.I2(Es);) => . ... </k>
// 	rule
// 		<currentTask> "parsing",Ss </currentTask>
// 		<k> (. => syntaxError("Method invocation is only allowed from within a method.")) ~> (I1.I2(Es);)  ... </k>

// -----------------------------------------------------------------------------

// 	rule
// 		<k> execute => ((root = new root(0);) ~> (root.init(0);)) </k>
// 		<error> _ => "Unknown execution error." </error>

end module