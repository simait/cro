/*
 * This file is part of CRO-SRP-K.
 *
 * Copyright (C) 2012 Simon Aittamaa <simon.aittamaa@ltu.se>.
 *
 * CRO-SRP-K is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CRO-SRP-K is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CRO-SRP-K.  If not, see <http://www.gnu.org/licenses/>.
 */

require "cro-core-semantic.k"

/* ************************************************************************** */

require "cro-srp-config.k"
require "cro-srp-syntax.k"

/* ************************************************************************** */

module CRO-SRP-SCHEDULE

	imports CRO-SRP-SYNTAX
	imports CRO-SRP-CONFIG
	
/* ************************************************************************** */

	syntax List ::= "enqueuByPriority" "(" Int "," Int "," K "," List ")"[function]

/* ************************************************************************** */

	rule
		enqueuByPriority(
			P:Int,
			C:Int,
			Msg:K,
			.List
		) => (
			ListItem(P, C, Msg)
			.List
		)

	rule
		enqueuByPriority(
			P1:Int,
			C1:Int,
			Msg1:K,
			ListItem(P2:Int, C2:Int, Msg2:K) T:List
		) => (
			ListItem(P1, C1, Msg1)
			ListItem(P2, C2, Msg2)
			T
		)
		when P1 >Int P2
	rule
		enqueuByPriority(
			P1:Int,
			C1:Int,
			Msg1:K,
			ListItem(P2:Int, C2:Int, Code2:K) T:List
		) => (
			ListItem(P2, C2, Code2) enqueuByPriority(P1, C1, Msg1, T)
		)
		when P1 <=Int P2

/* ************************************************************************** */

	syntax K ::= "restorePriority" "(" ")"

/* ************************************************************************** */

	rule
		<k> restorePriority() => . ... </k>
		<systempriority> ListItem(_:Int) => . ... </systempriority>

/* ************************************************************************** */

	syntax K ::= "schedule" "(" ")"

/* ************************************************************************** */

	rule
		<k> 
			schedule() =>
			Msg ~>
			restorePriority()
			...
		</k>
		<systempriority> (. => ListItem(P2:Int)) ListItem(P1:Int) ... </systempriority>
		<systemceiling> ListItem(C1:Int) ... </systemceiling>
		<messagequeue> ListItem(P2:Int, C2:Int, Msg:K) => . ... </messagequeue>
		when (P2 >Int P1) andBool (C2 >Int C1)				[transition]

	rule
		<k>
			schedule() => .
			...
		</k>
		<systempriority> ListItem(P1:Int) ... </systempriority>
		<systemceiling> ListItem(C1:Int) ... </systemceiling>
		<messagequeue> ListItem(P2:Int, C2:Int, _:K) ... </messagequeue>
		when notBool((P2 >Int P1) andBool (C2 >Int C1))			[transition]


/* ************************************************************************** */

	syntax K ::= "schedule" "(" Int "," Int "," Cmds ")"

/* ************************************************************************** */

	rule
		<k>
			schedule(P:Int, C:Int, Msg:Cmds) => . ...
		</k>
		<messagequeue> Ms:List => enqueuByPriority(P, C, Msg, Ms) </messagequeue>

/* ************************************************************************** */

endmodule