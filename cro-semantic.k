in cro-common
in cro-parser

module CRO-SEMANTIC

	imports CRO-COMMON + CRO-PARSER

	syntax K ::= "init" | "cleanup" | "halt" | "execute"

	kvar L OL		: Int
	kvar I I1 I2		: Id
	kvar Es			: Exps
	kvar Rho Env		: Map
	kvar Ss			: Stmts
	kvar Obj OldObj B	: Bag
	kvar T			: Type
	kvar V			: Val

// 	syntax K ::= "newUID" "(" ")"
// 	rule
// 		<nextUID> UID => UID +Int 1 </nextUID>

	syntax Val ::=
		"objectClosure" "(" Bag ")"
		| "methodClosure" "(" Int "," Ids "," Stmts ")"

	rule
		<k>
			init =>
				pushClass() ~>
				newClassName(root) ~>
				newClassEnv() ~>
				newClassAlloc() ~>
				lookupClass(root) ~>
				storeRoot() ~>
				popClass() ~>
				cleanup
			...
		</k>
		<env> Env => . </env>

	rule
		<k>
			I1 = new I2(Es); =>
				pushClass() ~>
// 				pushEnv() ~>
				newClassName(I2) ~>
				newClassEnv() ~>
				newClassAlloc() ~>
				lookupClass(I2) ~>
// 				popEnv() ~>
				storeClass(I1) ~>
// 				halt ~>
				popClass()
			...
		</k>

	syntax K ::= "newClassName" "(" Id ")"
	rule
		<k> newClassName(I) => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					(. => <thisClass> I </thisClass>)
				)
			) ...
		</classStack>

	syntax K ::= "newClassEnv" "(" ")"
	rule
		<k> newClassEnv() => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					(. => <classEnv> . </classEnv>)
				)
			) ...
		</classStack>

	syntax K ::= "newClassAlloc" "(" ")"
	rule
		<k> newClassAlloc() => . ... </k>
 		<classStack>
			ListItem(
				obj(
					Obj
					(. => <location> L </location>)
				)
			) ...
		</classStack>
		<nextLoc> L => L +Int 1 </nextLoc>

	syntax K ::= "lookupClass" "(" Id ")"
	rule
		<k> lookupClass(I) => Ss ... </k>
		<class>
			<name> I </name>
			<params> Es </params>
			<declarations> Ss </declarations>
		</class>

	syntax K ::= "env" "(" Map ")"
	syntax K ::= "obj" "(" Bag ")"

	syntax K ::= "pushClass" "(" ")"
	rule
		<k> pushClass() => . ... </k>
		<classStack> . => ListItem(obj(.Bag)) ... </classStack>

// 	syntax K ::= "pushEnv" "(" ")"
// 	rule
// 		<k> pushEnv() => . </k>
// 		<env> Rho => .Map </env>
// 		<envStack> . => ListItem(env(Rho)) ... </envStack>
		
	syntax K ::= "popClass" "(" ")"
	rule
		<k> popClass() => . ... </k>
		<classStack> ListItem(obj(Obj)) => . ... </classStack>

// 	syntax K ::= "popEnv" "(" ")"
// 	rule
// 		<k> popEnv() => . </k>
// 		<env> Env => Rho </env>
// 		<envStack> ListItem(env(Rho)) => . ... </envStack>

	syntax K ::= "storeRoot" "(" ")"
	rule
		<k> storeRoot() => . ... </k>
		<env> ... . => root |-> L </env>
		<classStack>
			ListItem(
				obj(
					Obj
					(<location> L </location> => .)
				)
			) ...
		</classStack>
		<store> ... (. => L |-> objectClosure(Obj)) ... </store>

	syntax K ::= "storeClass" "(" Id ")"
	rule
		<k> storeClass(I) => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					(<location> L </location> => .)
				)
			) ...
		</classStack>
		<store> ... (. => L |-> objectClosure(Obj)) ... </store>
		when notBool(I in keys(Rho))

	rule
		<k> module I {Ss} => Ss ... </k>

	rule
		<k> class I (Es) {Ss} => . ... </k>
		<classes>
			(. => <class>
				<name> I </name>
				<params> ids(Es) </params>
				<declarations> Ss </declarations>
			</class>) ...
		</classes>

	rule
		<k> var I : T := V; => . ... </k>

	rule
		<k> method I(Es) : T { Ss } => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					(<classEnv> Rho => Rho I |-> L </classEnv>)
					(<location> OL </location>)
				)
			) ...
		</classStack>
		<store> ... . => L |-> methodClosure(OL, ids(Es), Ss) ... </store>
		<nextLoc> L => L +Int 1 </nextLoc>
		when notBool(I in keys(Rho))

	rule
		<k> cleanup => . ... </k>
		<classes>
			B => .
		</classes>
// 	rule
// 		<k> execute => _`(_`)(root.init, 0); ... </k>

	syntax K ::= "lvalue" "(" K ")"

end module