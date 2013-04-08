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

	syntax K ::= "checkPriority" "(" Int "," MessageClosure "," K ")"

/* ************************************************************************** */

	rule
		<k>
			(checkPriority(P:Int, MC:MessageClosure, Cont:K) ~> _:K) =>
			(schedulingDone ~> Cont)
		</k>
		<systempriority> ListItem(CP:Int) ... </systempriority>
		<messagequeue> ... . => ListItem(P, MC) </messagequeue>
		when P <=Int CP

/* ************************************************************************** */

	rule
		<k>
			(checkPriority(P:Int, MC:MessageClosure, Cont:K) ~> K:K) =>
			K
		</k>
		<systempriority> ListItem(CP:Int) ... </systempriority>
		when P >Int CP

/* ************************************************************************** */

	syntax K ::= "checkCeiling" "(" Int "," MessageClosure "," K ")"

/* ************************************************************************** */

	rule
		<k>
			(
				checkCeiling(
					P:Int,
					messageClosure('_`(_`)(
						methodClosure(
							<object> locationValue(O:Int) </object>
							MB:Bag
						),,
						Vs:Values)
						),
					Cont:K
				) ~>
				_:K
			) => (
				schedulingDone ~> Cont
			)
		</k>
		<store>
			...
			O |-> objectClosure(
				<ceiling> OC:Int </ceiling>
				_:Bag
				)
			...
		</store>
		<systemceiling> ListItem(CC:Int) ... </systemceiling>
		<messagequeue>
			...
			. => ListItem(
				P,
				messageClosure(
					'_`(_`)(
						methodClosure(
							<object> locationValue(O:Int) </object>
							MB:Bag
						),,
						Vs:Values)
					)
				)
		</messagequeue>
		when OC <=Int CC

/* ************************************************************************** */

	rule
		<k>
			(
				checkCeiling(
					P:Int,
					messageClosure('_`(_`)(
						methodClosure(
							<object> locationValue(O:Int) </object>
							MB:Bag
						),,
						Vs:Values)
						),
					Cont:K
				) ~>
				K:K
			) => (
				K
			)
		</k>
		<store>
			...
			O |-> objectClosure(
				<ceiling> OC:Int </ceiling>
				_:Bag
				)
			...
		</store>
		<systemceiling> ListItem(CC:Int) ... </systemceiling>
		when OC >Int CC

/* ************************************************************************** */

	syntax K ::= "dispatch" "(" Int "," MessageClosure "," K ")"

/* ************************************************************************** */

	rule
		<k>
			dispatch(
				P:Int,
				messageClosure(E:Exp),
				Cont:K
			) =>
			pushPriority(P) ~>
			schedulingDone ~>
			(E;) ~>
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

	rule
		<k> scheduleHighestPriority => schedulingDone </k>
		<messagequeue> .List </messagequeue>
		<schedulenext> .List </schedulenext>

	rule
		<k> scheduleHighestPriority </k>
		<messagequeue>
			...
			. => ListItem(P2:Int, MC2:MessageClosure)
		</messagequeue>
		<schedulenext>
			ListItem(P1:Int, MC1:MessageClosure)
			(ListItem(P2:Int, MC2:MessageClosure) => .)
			...
		</schedulenext>
		when P1 >=Int P2

	rule
		<k> scheduleHighestPriority </k>
		<messagequeue>
			...
			. => ListItem(P1:Int, MC1:MessageClosure)
		</messagequeue>
		<schedulenext>
			(ListItem(P1:Int, MC1:MessageClosure) => .)
			ListItem(P2:Int, MC2:MessageClosure)
			...
		</schedulenext>
		when P2 >Int P1

	rule
		<k> scheduleHighestPriority => dispatch(P, MC, messageDone) </k>
		<schedulenext>
			(ListItem(P:Int, MC:MessageClosure) => .)
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

	syntax K ::= "schedule" "(" Int "," MessageClosure "," K ")"

/* ************************************************************************** */

	rule
		<k>
			schedule(P:Int, MC:MessageClosure, Cont:K) =>
			schedulingStart ~>
			checkPriority(P, MC, Cont) ~>
			checkCeiling(P, MC, Cont) ~>
			dispatch(P, MC, Cont)
		</k>

/* ************************************************************************** */

endmodule