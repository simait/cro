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

require "cro-core-parser.k"
require "cro-core-init.k"

module CRO-CORE-SEMANTIC

	imports CRO-CORE-SYNTAX
	imports CRO-CORE-INIT

/* ************************************************************************** */

	syntax K ::= "programExecute" | "halt" | "programDone"

/* ************************************************************************** */

	syntax Value ::=
		"location" "(" Int ")"

/* ************************************************************************** */

	syntax KResult ::= Value

/* ************************************************************************** */

	rule	/* Invoke the init method of the root object. */
		<k> programExecute => '_._(root,, init) ~> /*lookup(root) ~> */'_`(_`)('_._(root,, init),, .Values); ... </k>

/* ************************************************************************** */

	syntax K ::= "lookup" "(" Map "," Id ")"
	rule
		<k> lookup(X I |-> V Y, I:Id) => V:Value ... </k>

	rule
		<k> I:Id => lookup(M:Map, I) ... </k>
		<contexts> (_, M) ... </k>

	context	'_._(HOLE,, _:Id)
	rule
		<k> '_._(objectClosure(If:Map, _, _),, I:Id) => lookup(If, I) ... </k>
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
//
/* ************************************************************************** */



endmodule