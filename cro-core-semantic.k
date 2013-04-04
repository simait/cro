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

require "cro-core-parser.k"
require "cro-core-init.k"

/* ************************************************************************** */

module CRO-CORE-SEMANTIC-CONTEXTS

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-INIT

/* ************************************************************************** */

	syntax K ::= "lookup" "(" Id ")"
	rule
		<k> lookup(I:Id) => lookupM(Env:Map, I) ... </k>
		<contexts> (_:LocationValue, Env, _:K) ... </contexts>

/* ************************************************************************** */

	syntax StoreValue ::=
		Value
		| Location

	syntax K ::= "lookupM" "(" Map "," Id ")"

	rule
		<k> lookupM(I:Id |-> V:StoreValue _:Map, I) => V ... </k>
/*	rule
		<k> lookup(I:Id |-> L:Location _:Map, I) => L ... </k>*/

/* ************************************************************************** */

	syntax K ::= "contextEnter" "(" LocationValue "," K ")"
	rule
		<k> contextEnter(locationValue(L:Int), K:K) => . ... </k>
		<contexts> . => (locationValue(L), If:Map[B:Map[S:Map]], K) ... </contexts>
		<store>
			...
				L |-> objectClosure(
					_:Bag
					<interface> If </interface>
					<bindings> B </bindings>
					<state> S </state>
					_:Bag
				)
			...
		</store>

/* ************************************************************************** */

	syntax K ::= "contextLeave" "(" Value ")"
	rule
		<k> contextLeave(V:Value) ~> _:K => V ~> K:K </k>
		<contexts> (_:LocationValue, _:Map, K) => . ... </contexts>	[transition]


/* ************************************************************************** */

	syntax K ::= "contextBindAdd" "(" Id "," Value ")"
	rule
		<k> contextBindAdd(I:Id, V:Value) => . ... </k>
		<contexts> (_:LocationValue, Env:Map => Env[V/I], _:K) ... </contexts>

/* ************************************************************************** */

	syntax K ::= "this"
	rule
		<k> this => O:LocationValue ... </k>
		<contexts> (O, _:Map, _:K) ... </contexts>

/* ************************************************************************** */

endmodule

/* ************************************************************************** */

module CRO-CORE-SEMANTIC-OBJECTS-ACTIVATE

	imports CRO-CORE-SEMANTIC-OBJECTS

/* ************************************************************************** */

	rule
		<k> objectActivate(locationValue(L:Int)) => . ... </k>
		<store>
			...
				L |-> objectClosure(
					<active> false => true </active>
					_:Bag
				)
			...
		</store>							[transition]

/* ************************************************************************** */

	rule
		<k> objectDeactivate(locationValue(L:Int)) => . ... </k>
		<store>
			...
				L |-> objectClosure(
					<active> true => false </active>
					_:Bag
				)
			...
		</store>							[transition]

/* ************************************************************************** */

endmodule

/* ************************************************************************** */

module CRO-CORE-SEMANTIC-OBJECTS

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-INIT
	imports CRO-CORE-SEMANTIC-CONTEXTS

/* ************************************************************************** */

	syntax K ::= "objectActivate" "(" LocationValue ")"			[strict]

/* ************************************************************************** */

	syntax K ::= "objectDeactivate" "(" LocationValue ")"			[strict]

/* ************************************************************************** */

	rule
		'_._(O:Id,, I:Id) => O ~> '_._(HOLE,, I)			[heat]
	rule
		R:KResult ~> '_._(HOLE,, I:Id) => '_._(R,, I)			[cool]
	rule
		<k> '_._(objectClosure(<interface> If:Map </interface> _:Bag),, I:Id) => lookupM(If, I) ... </k>

/* ************************************************************************** */

	syntax ObjectState ::= "objectState" "(" Int ")"
	syntax ObjectState ::= "objectState" "(" Id ")"
	syntax Value ::= ObjectState

/* ************************************************************************** */

	rule
		<k> objectState(I:Id) => objectState(L:Int) ... </k>
		<contexts> (_:LocationValue, I |-> location(L) _:Map, _:K) ... </contexts>

/* ************************************************************************** */

	rule
		I:Id := E:Exp ; => objectState(I) ~> HOLE := E;			[heat]
	rule
		objectState(L:Int) ~> HOLE := E:Exp ; => objectState(L) := E ;	[cool]

	rule
		<k> objectState(L:Int) := V:Value ; => valueStore(L, V) ... </k>

/* ************************************************************************** */

endmodule

/* ************************************************************************** */

module CRO-CORE-SEMANTIC-MESSAGES

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-SEMANTIC-CONTEXTS
	imports CRO-CORE-SEMANTIC-OBJECTS

/* ************************************************************************** */

	syntax K ::= "messageDone"

/* ************************************************************************** */

	syntax K ::= "methodParamsBind" "(" Ids "," Values ")"
	rule
		<k> methodParamsBind(.Ids, .Values) => . ... </k>		[structural]
	rule
		<k>
			methodParamsBind((I:Id,Is:Ids), (V:Value,Vs:Values)) =>
				contextBindAdd(I, V) ~>
				methodParamsBind(Is, Vs)
			...
		</k>

/* ************************************************************************** */

	rule
		<k> '_`(_`)(methodClosure(
				<object> L:LocationValue </object>
				<params> Is:Ids </params>
				<commands> Cs:Cmds </commands>
			),, Vs:Values) ~> Return:K =>
				contextEnter(L, Return) ~>
				objectActivate(this) ~>
				methodParamsBind(Is, Vs) ~>
				Cs ~>
				return nothing; ~>
				messageDone
		</k>

/* ************************************************************************** */

	rule
		<k>
			return V:Value; =>
				objectDeactivate(this) ~>
				contextLeave(V)
			...
		</k>

/* ************************************************************************** */

	syntax MessageClosure ::= "messageClosure" "(" Exp ")"
	syntax Value ::= MessageClosure

/* ************************************************************************** */

	syntax K ::= "messageClosureCreate" "(" Exp ")"

	context messageClosureCreate('_`(_`)(HOLE,, _))
	context messageClosureCreate('_`(_`)(_,, HOLE))
	rule
		<k>
			messageClosureCreate('_`(_`)(M:Method,, Vs:Values)) => messageClosure('_`(_`)(M,, Vs))
			...
		</k>

/* ************************************************************************** */

	/*context send (HOLE => messageClosureCreate(HOLE));*/
	rule
		send E:Exp ; => messageClosureCreate(E) ~> send HOLE ;		[heat]
	rule
		R:KResult ~> send HOLE ; => send R ;				[cool]

/* ************************************************************************** */

	rule
		<k> V:Value ; => . ... </k>

/* ************************************************************************** */

endmodule

module CRO-CORE-SEMANTIC-MESSAGES-SEND

	imports CRO-CORE-SEMANTIC-MESSAGES

/* ************************************************************************** */
	rule
		<messages>
			<message>
				<k>
					send ( messageClosure('_`(_`)(M:Method,, Vs:Values)) ) ; => .
					...
				</k>
				...
			</message>
			(. =>
				<message>
					<k> '_`(_`)(M,, Vs); ~> messageDone </k>
					<contexts> .List </contexts>
				</message>
			)
			...
		</messages>							[transition]

/* ************************************************************************** */

endmodule

/* ************************************************************************** */

module CRO-CORE-SEMANTIC

	imports CRO-CORE-SEMANTIC-CONTEXTS
	imports CRO-CORE-SEMANTIC-MESSAGES

/* ************************************************************************** */

	syntax K ::= "programEval" | "programDone"

/* ************************************************************************** */

	rule
		<k> I:Id => lookup(I) ... </k>

/* ************************************************************************** */

	rule
		<k> location(L:Int) => valueLoad(L) ... </k>

/* ************************************************************************** */

	syntax KResult ::= Value

/* ************************************************************************** */

	rule	/* Invoke the init method of the root object. */
		<k> programEval => '_`(_`)('_._(root,, init),, .Values); ~> messageDone ... </k>

/* ************************************************************************** */

endmodule