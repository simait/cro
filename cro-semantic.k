/*
 * This file is part of CRO-EXEC.
 *
 * Copyright (C) 2012 Simon Aittamaa <simon.aittamaa@ltu.se>.
 *
 * CRO-EXEC is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CRO-EXEC is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CRO-EXEC.  If not, see <http://www.gnu.org/licenses/>.
 */
in cro-common
in cro-parser

module CRO-SEMANTIC

	imports CRO-COMMON + CRO-PARSER

	syntax K ::= "initProgram" | "executeProgram" | "halt" | "executeDone"

	kvar I I1 I2		: Id
	kvar Is			: Ids
	kvar B B1 B2		: Bool
	kvar L OL		: Int
	kvar Iv Iv1 Iv2		: Int
	kvar Str1 Str2		: String
	kvar UID		: Int
	kvar Env Rho		: Map
	kvar Obj PObj		: Bag
	kvar E			: Exp
	kvar Es			: Exps
	kvar T			: Type
	kvar V			: Val
	kvar Vs			: Vals
	kvar Ss			: Stmts
	kvar C K		: K

	syntax Val ::=
		"loc" "(" Int ")"
		| "objectClosure" "(" Bag ")"
		| "methodClosure" "(" Int "," Ids "," Stmts ")"

	syntax KResult ::= Val

/* ************************************************************************** */

	rule
		<k>
			initProgram =>
				newClass(root) ~>
				loadClass(root, .Vals) ~>
				storeRoot() ~>
				parseCleanup
			...
		</k>
		<env> Env => . </env>

	syntax K ::= "env" "(" Map ")"
	syntax K ::= "obj" "(" Bag ")"

	syntax K ::= "newClass" "(" Id ")"
	rule
		<k> newClass(I) => . ... </k>
		<classStack>
			. => ListItem(
				obj(
					<thisClass> I </thisClass>
					<classInterface> .Map </classInterface>
					<classEnv> .Map </classEnv>
					<locked> false </locked>
					<location> L </location>
				)
			)
			...
		</classStack>
		<nextLoc> L => L +Int 1 </nextLoc>

	syntax K ::= "loadClass" "(" Id "," Vals ")"
	rule
		<k> loadClass(I, Vs) => bindClassParams(Is, Vs) ~> Ss ... </k>
		<class>
			<name> I </name>
			<params> Is </params>
			<declarations> Ss </declarations>
		</class>

	syntax K ::= "bindClassParams" "(" Ids "," Vals ")"
	rule
		<k> bindClassParams((I,Is => Is), (V,Vs => Vs)) ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					<classEnv> Rho => Rho I |-> L </classEnv>
				)
			)
			...
		</classStack>
		<store> ... . => L |-> V </store>
		<nextLoc> L => L +Int 1 </nextLoc>
		when notBool(I in keys(Rho))

	rule
		<k> bindClassParams(.Ids, .Vals) => . ... </k>

	syntax K ::= "storeRoot" "(" ")"
	rule
		<k> storeRoot() => . ... </k>
		<env> ... . => root |-> L </env>
		<classStack>
			ListItem(
				obj(
					Obj
					(<location> L </location>)
				)
			) => .
			...
		</classStack>
		<store> ... (. => L |-> objectClosure(Obj)) ... </store>

	syntax K ::= "storeClass" "(" Id ")"
	rule
		<k> storeClass(I) => . ... </k>
		<classStack>
			(ListItem(
				obj(
					Obj
					<location> L </location>
				)
			) => .)
			ListItem(
				obj(
					PObj
					<classEnv> Rho => Rho I |-> L </classEnv>
				)
			)
			...
		</classStack>
		<store> ... . => L |-> objectClosure(Obj) ... </store>
		when notBool(I in keys(Rho))

	syntax K ::= "classEnvAdd" "(" Id "," Int ")"
	rule
		<k> classEnvAdd(I, L) => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					<classEnv> Rho => Rho I |-> L </classEnv>
				)
			)
			...
		</classStack>
		when notBool(I in keys(Rho))

	syntax K ::= "classInterfaceAdd" "(" Id "," Int ")"
	rule
		<k> classInterfaceAdd(I, L) => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					<classInterface> Rho => Rho I |-> L </classInterface>
				)
			)
			...
		</classStack>
		when notBool(I in keys(Rho))

/* ************************************************************************** */

	rule
		// NOTE:
		//	This actually relies on the fact that there will never
		//	be anything on the classStack when we execute, only
		//	during parsing. Perhaps it should be renamed parseStack?
		<k> var I : T := V; => . ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					<classEnv> Rho => Rho I |-> L </classEnv>
				)
			)
			...
		</classStack>
		<store> ... . => L |-> V ... </store>
		<nextLoc> L => L +Int 1 </nextLoc>

	rule
		<k>
			I1 = new I2(Vs); =>
				newClass(I2) ~>
				loadClass(I2, Vs) ~>
				storeClass(I1)
			...
		</k>

	rule
		<k> method I(Es) : T { Ss } => classEnvAdd(I, L) ~> classInterfaceAdd(I, L) ... </k>
		<classStack>
			ListItem(
				obj(
					Obj
					<location> OL </location>
				)
			)
			...
		</classStack>
		<store> ... . => L |-> methodClosure(OL, ids(Es), Ss) ... </store>
		<nextLoc> L => L +Int 1 </nextLoc>


/* ************************************************************************** */

	rule
		<k> executeProgram => send _`(_`)(_._(root, init), .Vals); ... </k>

/* ************************************************************************** */

	rule	<k> - Iv => 0 -Int Iv ... </k>
	rule	<k> Iv1 + Iv2 => Iv1 +Int Iv2 ... </k>
	rule	<k> _-_(Iv1,Iv2) => _-Int_(Iv1,Iv2) ... </k>
	rule	<k> Iv1 * Iv2 => Iv1 *Int Iv2 ... </k>
	rule	<k> Iv1 / Iv2 => Iv1 /Int Iv2 ... </k>		when notBool(Iv2 =/=Int 0)
	rule	<k> Iv1 % Iv2 => Iv1 %Int Iv2 ... </k>		when notBool(Iv2 =/=Int 0)

	rule	<k> Iv1 > Iv2 => Iv1 >Int Iv2 ... </k>
	rule	<k> Iv1 < Iv2 => Iv1 <Int Iv2 ... </k>
	rule	<k> Iv1 >= Iv2 => Iv1 >=Int Iv2 ... </k>
	rule	<k> Iv1 <= Iv2 => Iv1 <=Int Iv2 ... </k>
	rule	<k> Iv1 != Iv2 => Iv1 =/=Int Iv2 ... </k>
	rule	<k> Iv1 == Iv2 => Iv1 ==Int Iv2 ... </k>

	rule	<k> B1 or B2 => B1 orBool B1 ... </k>
	rule	<k> B1 and B2 => B1 andBool B2 ... </k>
	rule	<k> not B => notBool B ... </k>

	rule	<k> Str1 + Str2 => Str1 +String Str2 ... </k>

/* ************************************************************************** */

	syntax K ::= "lookupInterface" "(" Val "," Id ")"
	context lookupInterface(HOLE, _)
	rule
		<k> lookupInterface(objectClosure(Obj <classInterface> ... I |-> L ... </classInterface>), I) => V ... </k>
		<store> ... L |-> V ... </store>

	syntax K ::= "lookup" "(" Id ")"
	rule
		<k> lookup(I) => V ... </k>
		<env> ... I |-> L </env>
		<store> ... L |-> V ... </store>

	syntax K ::= "lockObject" "(" Int ")"
	syntax K ::= "locked" "(" Int "," Int ")"
	rule
		<k> lockObject(L) => . ... </k>
		<uid> UID </uid>
		<objStack> . => ListItem(L) ... </objStack>
		<store> ... L |-> objectClosure(Obj <locked> false => true </locked>) ... </store>
		<events> ... . => ListItem(locked(UID, L)) </events>							[transition]

	syntax K ::= "unlockObject" "(" ")"
	syntax K ::= "unlocked" "(" Int "," Int ")"
	rule
		<k> unlockObject() => . ... </k>
		<uid> UID </uid>
		<objStack> ListItem(L) => . ... </objStack>
		<store> ... L |-> objectClosure(Obj <locked> true => false </locked>) ... </store>
		<events> ... . => ListItem(unlocked(UID, L)) </events>							[transition]

	syntax ListItem ::= "(" Map "," K ")"
	syntax K ::= "pushContext" "(" K ")"
	rule
		<k> pushContext(C) => . ... </k>
		<env> Env => . </env>
		<envStack> . => (Env, C) ... </envStack>

	syntax K ::= "popContext" "(" Val ")"
	rule
		<k> popContext(V) ~> K => V ~> C </k>
		<env> Env => Rho </env>
		<envStack> (Rho, C) => . ... </envStack>

	syntax K ::= "loadClassEnv" "(" Int ")"
	rule
		<k> loadClassEnv(L) => . ... </k>
		<env> Env => Rho </env>
		<store> ... L |-> objectClosure(Obj <classEnv> Rho </classEnv>) ... </store>

	syntax K ::= "bindParams" "(" Ids "," Vals ")"

	rule
		<k> bindParams((I,Is => Is), (V,Vs => Vs)) ... </k>
		<env> Env => Env[L/I] </env>
		<store> ... . => L |-> V </store>
		<nextLoc> L => L +Int 1 </nextLoc>
	rule
		<k> bindParams(.Ids, .Vals) => . ... </k>

	syntax K ::= "lvalue" "(" Id ")"
	rule
		<k> lvalue(I) => loc(L) ... </k>
		<env> ... I |-> L ... </env>

/* ************************************************************************** */

	rule
		// NOTE:
		//	Just like variable declarations in classes this assumes
		//	that if the classStack is empty then we are executing a
		//	method, a bit of an ugly hack but ok for now...
		<k> var I : T := V; => . ... </k>
		<env> ... . => I |-> L </env>
		<store> ... . => L |-> V </store>
		<nextLoc> L => L +Int 1 </nextLoc>
		<classStack> .List </classStack>


	rule
		<k> print((V,Vs => Vs)); ... </k>
		<output> ... . => ListItem(V) </output>
	rule
		<k> print(.Vals); => . ... </k>

	rule
		<k> I => lookup(I) ... </k>
		<env> Rho </env>
		when I in keys(Rho)

	context _ := HOLE ;
	context (HOLE => lvalue(HOLE)) := _ ;
	rule
		<k> loc(L) := V ;  => . ... </k>
		<store> ... L |-> (_ => V) ... </store>

	rule
		<k> if (true) Ss else _ => Ss ... </k>

	rule
		<k> if (false) _ else Ss => Ss ... </k>

	rule
		<k> {} => . ... </k>

	rule
		<k> {Ss} => Ss ... </k>

/* ************************************************************************** */

	rule
		<k> _._(I1,I2) => lookupInterface(lookup(I1), I2) ... </k>

	rule
		<k> _`(_`)(I, Vs) => _`(_`)(lookup(I), Vs) ... </k>

	rule
		<k>
			_`(_`)(methodClosure(OL, Is, Ss), Vs) ~> C =>
				pushContext(C) ~>
				lockObject(OL) ~>
				loadClassEnv(OL) ~>
				bindParams(Is, Vs) ~>
				Ss ~>
				return nothing;
		</k>

	rule
		<k> return V; => unlockObject() ~> popContext(V) ... </k>

	rule
		<k> V; => . ... </k>

/* ************************************************************************** */

	syntax Val ::= "messageClosure" "(" Val "," Vals ")"
	syntax K ::= "createMessageClosure" "(" Exp ")"
	context createMessageClosure('_`(_`)(HOLE,,_))
	context createMessageClosure('_`(_`)(_,,HOLE))
	rule
		<k> createMessageClosure(_`(_`)(V, Vs)) => messageClosure(V, Vs) ... </k>

	syntax K ::= "sent" "(" Int ")"
	context send (HOLE => createMessageClosure(HOLE));
	rule
		<messages>
			<message>
				...
				<k> send messageClosure(V, Vs) ; => . ... </k>
				...
			</message>
			(. => <message>
					<k> _`(_`)(V, Vs); </uid>
					<uid> UID </uid>
					<env> .Map </env>
					<objStack> .List </objStack>
					<envStack> .List </envStack>
			</message>)
			...
		</messages>
		<nextUID> UID => UID +Int 1 </nextUID>
		<events> ... . => ListItem(sent(UID))</events>				[transition]

	rule
		<message>
			...
			<k> .K </k>
			...
		</message> => .

	/* Cleanup rule for state that is "irrelevant". */
	rule
		<messages>
			.Bag =>
			<message>
				<k> executeDone </k>
			</message>
		</messages>
		<nextUID> _ => 0 </nextUID>
		<store>
			_ => .
		</store>
		<input>
			_ => .
		</input>
		<output>
			_ => .
		</output>
		<nextLoc> _ => 0 </nextLoc>

end module