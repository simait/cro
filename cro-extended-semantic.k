/*
 * This file is part of CRO-EXTENDED-K.
 *
 * Copyright (C) 2012 Simon Aittamaa <simon.aittamaa@ltu.se>.
 *
 * CRO-EXTENDED-K is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CRO-EXTENDED-K is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CRO-EXTENDED-K.  If not, see <http://www.gnu.org/licenses/>.
 */

require "cro-extended-syntax.k"

module CRO-EXTENDED-SEMANTIC

// 	imports CRO-CORE-INIT
	imports CRO-EXTENDED-SYNTAX

/* ************************************************************************** */

	rule	<k> - I0:Int			=> 0 -Int I0 ... </k>
	rule	<k> I0:Int + I1:Int		=> I0 +Int I1 ... </k>
	rule	<k> I0:Int - I1:Int		=> I0 -Int I1 ... </k>
	rule	<k> I0:Int * I1:Int		=> I0 *Int I1 ... </k>
	rule	<k> I0:Int / I1:Int		=> I0 /Int I1 ... </k>		when notBool(I1 =/=Int 0)
	rule	<k> I0:Int % I1:Int		=> I0 %Int I1 ... </k>		when notBool(I1 =/=Int 0)

/* ************************************************************************** */

	rule	<k> I0:Int > I1:Int		=> I0 >Int I1 ... </k>
	rule	<k> I0:Int < I1:Int		=> I0 <Int I1 ... </k>
	rule	<k> I0:Int >= I1:Int		=> I0 >=Int I1 ... </k>
	rule	<k> I0:Int <= I1:Int		=> I0 <=Int I1 ... </k>
	rule	<k> I0:Int != I1:Int		=> I0 =/=Int I1 ... </k>
	rule	<k> I0:Int == I1:Int		=> I0 ==Int I1 ... </k>

/* ************************************************************************** */

	rule	<k> B0:Bool or B1:Bool		=> B1 orBool B1 ... </k>
	rule	<k> B0:Bool and B1:Bool		=> B0 andBool B1 ... </k>
	rule	<k> not B0:Bool			=> notBool B0 ... </k>

/* ************************************************************************** */

	rule	<k> S0:String + S1:String	=> S0 +String S1 ... </k>

/* ************************************************************************** */

	rule	if (E:Exp) T:Cmd => if (E) T else {}				[structural]
	rule	<k> if (true) C:Cmd else _:Cmd => C ... </k>
	rule	<k> if (false) _:Cmd else C:Cmd => C ... </k>

/* ************************************************************************** */

	rule	<k> while (E:Exp) {Cs:Cmds} => if (E) {Cs while (E) {Cs}} ... </k>

/* ************************************************************************** */

	rule	<k> { Cs:Cmds } => Cs ... </k>					[structural]

/* ************************************************************************** */

endmodule