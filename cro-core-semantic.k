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

	syntax K ::= "lookup" "(" Map "," Id ")"
	rule
		<k> lookup(X I |-> V Y, I:Id) => V:Value ... </k>

/* ************************************************************************** */

	rule
		<k> I:Id => lookup(Env:Map, I) ... </k>
		<contexts> (_:Location, Env, _:K) ... </k>

/* ************************************************************************** */

	syntax K ::= "contextEnter" "(" Location "," K ")"
	rule
		<k> contextEnter(location(L:Int), K:K) => . ... </k>
		<contexts> . => (location(L), If:Map[B:Map[S:Map]], K) ... </contexts>
		<store>
			...
				L |-> objectClosure(
					X
					<interface> If </interface>
					<bindings> B </bindings>
					<state> S </state>
					Y
				)
			...
		</store>

/* ************************************************************************** */

	syntax K ::= "contextLeave" "(" Value ")"
	rule
		<k> contextLeave(V:Value) ~> _:K => V ~> K:K </k>
		<contexts> (_:Location,_:Map, K) => . ... </contexts>


/* ************************************************************************** */

	syntax K ::= "contextBindAdd" "(" Id "," Value ")"
	rule
		<k> contextBindAdd(I:Id, V:Value) => . ... </k>
		<contexts> (_:Location, Env:Map => Env[V/I], _:K) ... </contexts>

/* ************************************************************************** */

	syntax K ::= "this"
	rule
		<k> this => L:Location ... </k>
		<contexts> (L, _:Map, _:K) ... </contexts>

/* ************************************************************************** */

endmodule

/* ************************************************************************** */

module CRO-CORE-SEMANTIC-OBJECTS

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-INIT
	imports CRO-CORE-SEMANTIC-CONTEXTS

/* ************************************************************************** */

	syntax K ::= "objectActivate" "(" Location ")"				[strict]
	rule
		<k> objectActivate(location(L:Int)) => . ... </k>
		<store>
			...
				L |-> objectClosure(
					X
					<active> false => true </active>
					Y
				)
			...
		</store>

/* ************************************************************************** */

	syntax K ::= "objectDeactivate" "(" Location ")"			[strict]
	rule
		<k> objectDeactivate(location(L:Int)) => . ... </k>
		<store>
			...
				L |-> objectClosure(
					X
					<active> true => false </active>
					Y
				)
			...
		</store>

/* ************************************************************************** */

	context	'_._(HOLE,, _:Id)
	rule
		<k> '_._(location(L:Int),, I:Id) => '_._(valueLoad(L),, I) ... </k>
	rule
		<k> '_._(objectClosure(X <interface> If:Map </interface> Y),, I:Id) => lookup(If, I) ... </k>

/* ************************************************************************** */

	rule
		<k> location(L:Int) := V:Value ; => . ... </k>
		<store> Rho:Map => Rho[V/L] </store>

/* ************************************************************************** */

endmodule

/* ************************************************************************** */

module CRO-CORE-SEMANTIC-MESSAGES

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-INIT
	imports CRO-CORE-SEMANTIC-CONTEXTS
	imports CRO-CORE-SEMANTIC-OBJECTS

/* ************************************************************************** */

	syntax MessageClosure ::= "messageClosure" "(" Exp ")"

	syntax K ::= "messageDone"

	syntax Value ::= MessageClosure

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
		<k> '_`(_`)(location(L:Int),, Vs:Values) => '_`(_`)(valueLoad(L),, Vs) ... </k>
	rule
		<k> '_`(_`)(methodClosure(
				<object> L:Location </object>
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

	syntax K ::= "messageClosureCreate" "(" Exp ")"
	context messageClosureCreate('_`(_`)(HOLE,, _))
	context messageClosureCreate('_`(_`)(_,, HOLE))
	rule
		<k> messageClosureCreate('_`(_`)(location(L:Int),, Vs:Values) => '_`(_`)(valueLoad(L),, Vs)) ... </k>

	rule
		<k> messageClosureCreate('_`(_`)(M:Method,, Vs:Values)) => messageClosure('_`(_`)(M,, Vs)) ... </k>
	context send (HOLE => messageClosureCreate(HOLE));
	rule
			<message>
				... <k> send messageClosure('_`(_`)(M:Method,, Vs:Values)) ; => . ... </k> ...
			</message>
			(. =>
				<message>
					<k> '_`(_`)(M,, Vs); ~> messageDone </k>
					<contexts> .List </contexts>
				</message>
			)

/* ************************************************************************** */

	rule
		<k> V:Value ; => . ... </k>

/* ************************************************************************** */

endmodule


/* ************************************************************************** */

// 	rule	<k> - Iv => 0 -Int Iv ... </k>
// 	rule	<k> Iv1 + Iv2 => Iv1 +Int Iv2 ... </k>
// 	rule	<k> _-_(Iv1,Iv2) => _-Int_(Iv1,Iv2) ... </k>
// 	rule	<k> Iv1 * Iv2 => Iv1 *Int Iv2 ... </k>
// 	rule	<k> Iv1 / Iv2 => Iv1 /Int Iv2 ... </k>		when notBool(Iv2 =/=Int 0)
// 	rule	<k> Iv1 % Iv2 => Iv1 %Int Iv2 ... </k>		when notBool(Iv2 =/=Int 0)
//
// 	rule	<k> Iv1 > Iv2 => Iv1 >Int Iv2 ... </k>
// 	rule	<k> Iv1 < Iv2 => Iv1 <Int Iv2 ... </k>
// 	rule	<k> Iv1 >= Iv2 => Iv1 >=Int Iv2 ... </k>
// 	rule	<k> Iv1 <= Iv2 => Iv1 <=Int Iv2 ... </k>
// 	rule	<k> Iv1 != Iv2 => Iv1 =/=Int Iv2 ... </k>
// 	rule	<k> Iv1 == Iv2 => Iv1 ==Int Iv2 ... </k>
//
// 	rule	<k> B1 or B2 => B1 orBool B1 ... </k>
// 	rule	<k> B1 and B2 => B1 andBool B2 ... </k>
// 	rule	<k> not B => notBool B ... </k>
//
// 	rule	<k> Str1 + Str2 => Str1 +String Str2 ... </k>

/* ************************************************************************** */

module CRO-CORE-SEMANTIC

	imports CRO-CORE-SEMANTIC-CONTEXTS
	imports CRO-CORE-SEMANTIC-MESSAGES

/* ************************************************************************** */

	syntax K ::= "programEval" | "programDone"// | "halt"

/* ************************************************************************** */

	syntax KResult ::= Value

/* ************************************************************************** */

	rule	/* Invoke the init method of the root object. */
		<k> programEval => '_`(_`)('_._(root,, init),, .Values); ~> messageDone ... </k>

/* ************************************************************************** */

endmodule