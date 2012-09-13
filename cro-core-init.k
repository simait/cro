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

require "cro-core-syntax.k"

module CRO-CORE-INIT

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-PARSER

	syntax Object ::= "objectClosure" "(" Map "," Map "," Map ")"
	syntax Method ::= "methodClosure" "(" Ids "," Cmds ")"

	syntax ListItem ::= "(" Value "," Map ")"

	syntax Value ::=
		Object
		| Method

	syntax Id ::= "active"

	syntax K ::= "programInit"

/* ************************************************************************** */

	syntax K ::= "valueStore" "(" Value ")"					[strict]
	rule
		<k> valueStore( V:Value ) => L:Int ... </k>
		<store> (. => L |-> V) Rho:Map </store>
		<nextLocation> L => L +Int 1 </nextLocation>
		when notBool(L in keys(Rho))

/* ************************************************************************** */

	syntax K ::= "valueLoad" "(" Int ")"					[strict]
	rule
		<k> valueLoad(L:Int) => V:Value ... </k>
		<store> ... L |-> V ... </store>

/* ************************************************************************** */

	syntax K ::= "objectBindAdd" "(" Id "," Int ")"				[strict(2)]
	syntax K ::= "objectBindAddAll" "(" Ids "," Values ")"			[strict(2)]
	syntax K ::= "objectStateAdd" "(" Id "," Int ")"			[strict(2)]
	syntax K ::= "objectInterfaceAdd" "(" Id "," Int ")"			[strict(2)]
	syntax K ::= "objectCreate" "(" Id "," Values ")"			[strict(2)]
	syntax K ::= "objectPush" "(" Object ")"				[strict]
	syntax K ::= "objectPop" "(" ")"

/* ************************************************************************** */

	syntax K ::= "contextsInit" "(" Int ")"					[strict]

/* ************************************************************************** */

	rule
		<k> contextsInit(O:Object) => . ... </k>
		<contexts> . => (nothing, root |-> O) </contexts>

/* ************************************************************************** */

	rule	/* Init is equivalent to creating the root object. */
		<k> programInit => contextsInit(objectCreate(root, .Values)) ... </k>

/* ************************************************************************** */

	rule	/* Object creation. */
		<k>
			objectCreate(I:Id, Vs:Values) =>
				objectPush(objectClosure(.Map, .Map, .Map)) ~>
				objectStateAdd(active, valueStore(false)) ~>
				objectBindAddAll(Is:Ids, Vs) ~>
				Cs:Cmds ~>
				objectPop()
			...
		</k>
		<classes>
			...
			I |-> class(Is, Cs)
			...
		</classes>

/* ************************************************************************** */

	rule	/* Push object onto context stack. */
		<k> objectPush(O:Object) => . ... </k>
		<contexts> . => ListItem(O) ... </contexts>

	rule	/* Leave object from context stack. */
		<k> objectPop() => O:Object ... </k>
		<contexts> ListItem(O) => . ... </contexts>

/* ************************************************************************** */

	rule	/* Add identifier to the object interface. */
		<k> objectInterfaceAdd(I:Id, V:Value) => . ... </k>
		<contexts> ListItem(objectClosure(Interface:Map => Interface[V/I], _, _)) ... </contexts>

/* ************************************************************************** */

	rule	/* Add a single binding. */
		<k> objectBindAdd(I:Id, V:Value) => . ... </k>
		<contexts> ListItem(objectClosure(_, Bindings:Map => Bindings[V/I], _)) ... </contexts>

	rule	/* Termination condition (base-case). */
		<k> objectBindAddAll(.Ids, .Values) => . ... </k>		[structural]

	rule	/* Bind one value and recurse over the tail. */
		<k> objectBindAddAll((I:Id,Is:Ids), (V:Value,Vs:Values)) => objectBindAdd(I, V) ~> objectBindAddAll(Is, Vs) ... </k>

/* ************************************************************************** */

	rule	/* Add a state variable. */
		<k> objectStateAdd(I:Id, L:Int) => . ... </k>
		<contexts> ListItem(objectClosure(_, _, State:Map => State[L/I])) ... </contexts>

/* ************************************************************************** */


	rule	/* Method declaration. */
		<k> method I:Id (Is:Ids) {Cs:Cmds} => objectInterfaceAdd(I, methodClosure(Is, Cs)) ... </k>

/* ************************************************************************** */

	rule	/* Class bindings. */
		<k> I:Id = new C:Id (Vs:Values); => objectBindAdd(I, objectCreate(C, Vs)) ... </k>

/* ************************************************************************** */

	rule	/* Variable declaration. */
		<k> var I:Id := V:Value; => objectStateAdd(I, valueStore(V)) ... </k>

/* ************************************************************************** */

endmodule