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

	syntax K ::= "schedulingStart"

/* ************************************************************************** */

	rule
		<k> schedulingStart => . ... </k>
		<scheduling> false => true </scheduling>			[transition]

/* ************************************************************************** */

	syntax K ::= "schedulingDone"

/* ************************************************************************** */

	rule
		<k> schedulingDone => . ... </k>
		<scheduling> true => false </scheduling>			[transition]

/* ************************************************************************** */

	syntax K ::= "pushPriority" "(" Int ")"

/* ************************************************************************** */

	rule
		<k> pushPriority(P:Int) => . ... </k>
		<systempriority> . => ListItem(P) ... </systempriority>		[transition]

/* ************************************************************************** */

	syntax K ::= "popPriority" "(" ")"

/* ************************************************************************** */

	rule
		<k> popPriority() => . ... </k>
		<systempriority> ListItem(_:Int) => . ... </systempriority>	[transition]

/* ************************************************************************** */

	syntax K ::= "checkPriority" "(" Int "," Int "," K "," K ")"

/* ************************************************************************** */

	rule
		<k>
			(checkPriority(P:Int, C:Int, Code:K, Cont:K) ~> _:K) =>
			(schedulingDone ~> Cont)
		</k>
		<systempriority> ListItem(CP:Int) ... </systempriority>
		<messagequeue> ... . => ListItem(P, C, Code) </messagequeue>
		when P <=Int CP

/* ************************************************************************** */

	rule
		<k>
			(checkPriority(P:Int, C:Int, Code:K, Cont:K) ~> K:K) =>
			K
		</k>
		<systempriority> ListItem(CP:Int) ... </systempriority>
		when P >Int CP

/* ************************************************************************** */

	syntax K ::= "checkCeiling" "(" Int "," Int "," K "," K ")"

/* ************************************************************************** */

	rule
		<k>
			(checkCeiling(P:Int, C:Int, Code:K, Cont:K) ~> K) =>
			(schedulingDone ~> Cont)
		</k>
		<systemceiling> ListItem(CC:Int) ... </systemceiling>
		<messagequeue>
			...
			. => ListItem(
				P,
				C,
				Code
				)
		</messagequeue>
		when C <=Int CC

/* ************************************************************************** */

	rule
		<k>
			(checkCeiling(P:Int, C:Int, Code:K, Cont:K) ~> K) =>
			(K)
		</k>
		<systemceiling> ListItem(CC:Int) ... </systemceiling>
		when C >Int CC

/* ************************************************************************** */

	syntax K ::= "dispatch" "(" Int "," Int "," K "," K ")"

/* ************************************************************************** */

	rule
		<k>
			dispatch(
				P:Int,
				C:Int,
				Code:K,
				Cont:K
			) =>
			pushPriority(P) ~>
			schedulingDone ~>
			Code ~>
			schedulingStart ~>
			popPriority() ~>
			schedulingDone ~>
			Cont
		</k>


/* ************************************************************************** */

	syntax K ::= "scheduleHighestPriority"

/* ************************************************************************** */

	rule
		<k> scheduleHighestPriority </k>
		<messagequeue> Messages:List => .List </messagequeue>
		<schedulenext> . => Messages </schedulenext>
		when lengthList(Messages) =/=Int 0

/* ************************************************************************** */

	rule
		<k> scheduleHighestPriority => schedulingDone </k>
		<messagequeue> .List </messagequeue>
		<schedulenext> .List </schedulenext>

/* ************************************************************************** */

	rule
		<k> scheduleHighestPriority </k>
		<messagequeue>
			...
			. => ListItem(P2:Int, C2:Int, Code2:K)
		</messagequeue>
		<schedulenext>
			ListItem(P1:Int, C1:Int, Code1:K)
			(ListItem(P2:Int, C2:Int, Code2:K) => .)
			...
		</schedulenext>
		when P1 >=Int P2

/* ************************************************************************** */

	rule
		<k> scheduleHighestPriority </k>
		<messagequeue>
			...
			. => ListItem(P1:Int, C1:Int, Code1:K)
		</messagequeue>
		<schedulenext>
			(ListItem(P1:Int, C1:Int, Code1:K) => .)
			ListItem(P2:Int, C2:Int, Code2:K)
			...
		</schedulenext>
		when P2 >Int P1

/* ************************************************************************** */

	rule
		<k> scheduleHighestPriority => dispatch(P, C, Code, messageDone) </k>
		<schedulenext>
			(ListItem(P:Int, C:Int, Code:K) => .)
			.List
		</schedulenext>

/* ************************************************************************** */

	syntax K ::= "schedule" "(" ")"

/* ************************************************************************** */

	rule
		<k> 
			schedule() =>
			schedulingStart ~> 
			scheduleHighestPriority
			...
		</k>

/* ************************************************************************** */

	syntax K ::= "schedule" "(" Int "," Int "," K "," K ")"

/* ************************************************************************** */

	rule
		<k>
			schedule(P:Int, C:Int, Code:K, Cont:K) =>
			schedulingStart ~>
			checkPriority(P, C, Code, Cont) ~>
			checkCeiling(P, C, Code, Cont) ~>
			dispatch(P, C, Code, Cont)
		</k>

/* ************************************************************************** */

endmodule