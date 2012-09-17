/*
 * This file is part of CRO-CORE-K.
 *
 * Copyright (C) 2012 Simon Aittamaa <simon.aittamaa@ltu.se>.
 *
 * CRO-CORE-K is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CRO-CORE-K is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CRO-CORE-K.  If not, see <http://www.gnu.org/licenses/>.
 */

require "cro-core-syntax.k"

module CRO-CORE-INIT

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-PARSER

	syntax Object ::= "objectClosure" "(" Bag ")" //Map "," Map "," Map ")" | "objectNone"
	syntax Method ::= "methodClosure" "(" Bag ")" /* "," Ids "," Cmds ")"*/

	syntax ListItem ::= "(" Location "," Map "," K ")"

	syntax Location ::= "location" "(" Int ")" | "locationVoid"

	syntax Value ::=
		Object
		| Method
		| Location

	syntax CellLabel ::= "interface" | "bindings" | "state" | "active"
// 	syntax ObjectLabel ::= "interface" | "bindings" | "state" | "active"
// 	syntax CellLabel ::= ObjectLabels

	syntax CellLabel ::= "object" | "params" | "commands"
// 	syntax MethodLabel ::= "parameters" | "commands"
// 	syntax CellLabel ::= MethodLabel

	syntax K ::= "programInit"

	syntax KResult ::= Value

/* ************************************************************************** */

	syntax K ::= "valueStore" "(" Value ")"					[strict]
	rule
		<k> valueStore( V:Value ) => location(L:Int) ... </k>
		<store> (. => L |-> V) Rho:Map </store>
		<nextLocation> L => L +Int 1 </nextLocation>
		when notBool(L in keys(Rho))

/* ************************************************************************** */

	syntax K ::= "valueLoad" "(" Int ")"					[strict]
	rule
		<k> valueLoad(L:Int) => V:Value ... </k>
		<store> ... L |-> V ... </store>

/* ************************************************************************** */

	syntax K ::= "objectBindAdd" "(" Id "," Value ")"			[strict(2)]
	syntax K ::= "objectBindAddAll" "(" Ids "," Values ")"			[strict(2)]
	syntax K ::= "objectStateAdd" "(" Id "," Location ")"			[strict(2)]
	syntax K ::= "objectInterfaceAdd" "(" Id "," Location ")"		[strict(2)]
	syntax K ::= "objectCreate" "(" Id "," Values ")"			[strict(2)]
	syntax K ::= "objectPush" "(" Location ")"				[strict]
	syntax K ::= "objectPop" "(" ")"

/* ************************************************************************** */

	syntax K ::= "contextsInit" "(" Int ")"					[strict]

/* ************************************************************************** */

	rule
		<k> contextsInit(O:Location) => . ... </k>
		<contexts> . => (locationVoid, root |-> O, .K) </contexts>

/* ************************************************************************** */

	rule	/* Init is equivalent to creating the root object. */
		<k> programInit => contextsInit(objectCreate(root, .Values)) ... </k>

/* ************************************************************************** */

	rule	/* Object creation. */
		<k>
			objectCreate(I:Id, Vs:Values) =>
				objectPush(
					valueStore(
						objectClosure(
							<interface> .Map </interface>
							<bindings> .Map </bindings>
							<state> .Map </state>
							<active> false </active>
						)
					)
				) ~>
// 				objectStateAdd(active, valueStore(false)) ~>
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
		<k> objectPush(O:Location) => . ... </k>
		<contexts> . => ListItem(O) ... </contexts>

	rule	/* Leave object from context stack. */
		<k> objectPop() => O:Location ... </k>
		<contexts> ListItem(O) => . ... </contexts>

/* ************************************************************************** */

	rule	/* Add identifier to the object interface. */
		<k> objectInterfaceAdd(I:Id, L:Location) => . ... </k>
		<contexts> ListItem(location(O:Int)) ... </contexts>
		<store>
			...
				O |-> objectClosure(
					X
					<interface> If:Map => If[L/I] </interface>
					Y
				)
			...
		</store>

/* ************************************************************************** */

	rule	/* Add a single binding. */
		<k> objectBindAdd(I:Id, V:Value) => . ... </k>
		<contexts> ListItem(location(O:Int)) ... </contexts>
		<store>
			...
				O |-> objectClosure(
					X
					<bindings> B:Map => B[V/I] </bindings>
					Y
				)
			...
		</store>

	rule	/* Termination condition (base-case). */
		<k> objectBindAddAll(.Ids, .Values) => . ... </k>		[structural]

	rule	/* Bind one value and recurse over the tail. */
		<k>
			objectBindAddAll((I:Id,Is:Ids), (V:Value,Vs:Values)) =>
				objectBindAdd(I, V) ~>
				objectBindAddAll(Is, Vs)
			...
		</k>

/* ************************************************************************** */

	rule	/* Add a state variable. */
		<k> objectStateAdd(I:Id, L:Location) => . ... </k>
		<contexts> ListItem(location(O:Int)) ... </contexts>
		<store>
			...
				O |-> objectClosure(
					X
					<state> S:Map => S[L/I] </state>
					Y
				)
			...
		</store>

/* ************************************************************************** */


	rule	/* Method declaration. */
		<k>
			method I:Id (Is:Ids) {Cs:Cmds} =>
				objectInterfaceAdd(I,
					valueStore(
						methodClosure(
							<object> O </object>
							<params> Is </params>
							<commands> Cs </commands>
						)
					)
				)
			...
		</k>
		<contexts> ListItem(O:Location) ... </contexts>

/* ************************************************************************** */

	rule	/* Class bindings. */
		<k> I:Id = new C:Id (Vs:Values); => objectBindAdd(I, objectCreate(C, Vs)) ... </k>

/* ************************************************************************** */

	rule	/* Variable declaration. */
		<k> var I:Id := V:Value; => objectStateAdd(I, valueStore(V)) ... </k>

/* ************************************************************************** */

endmodule