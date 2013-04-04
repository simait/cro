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

/* ************************************************************************** */

module CRO-SRP-SEMANTIC-MESSAGES-SEND

	imports CRO-CORE-SEMANTIC-MESSAGES

/* ************************************************************************** */

	syntax K ::= "schedule" "(" Method "," Values ")"

/* ************************************************************************** */

	rule
		<k>
			schedule (
				methodClosure(
					<object> locationValue(O:Int) </object>
					<params> Is:Ids </params>
					<commands> Cs:Cmds </commands>
				),
				Vs:Values
			) => '_`(_`)(
					methodClosure(
						<object> locationValue(O:Int) </object>
						<params> Is:Ids </params>
						<commands> Cs:Cmds </commands>
					),,
					Vs:Values
				) ;
			...
		</k>
		<systemceiling> ListItem(CC:Int) ... </systemceiling>
		<store>
			...
			L |-> objectClosure(<ceiling> OC:Int </ceiling> _:Bag)
			...
		</store>
		when OC >Int CC:Int						[transition]

/* ************************************************************************** */

	syntax ListItem ::= "(" Method "," Values ")"

/* ************************************************************************** */

	rule
		<k>
			schedule (
				methodClosure(
					<object> locationValue(O:Int) </object>
					<params> Is:Ids </params>
					<commands> Cs:Cmds </commands>
				),
				Vs:Values
			) => .
			...
		</k>
		<systemceiling> ListItem(CC:Int) ... </systemceiling>
		<messagequeue>
			. => ListItem(
				methodClosure(
					<object> locationValue(O:Int) </object>
					<params> Is:Ids </params>
					<commands> Cs:Cmds </commands>
				),
				Vs:Values
			) ...
		</messagequeue>
		<store>
			...
			L |-> objectClosure(<ceiling> OC:Int </ceiling> _:Bag)
			...
		</store>
		when OC <=Int CC:Int						[transition]

/* ************************************************************************** */

	rule
		<k> messageDone => schedule(MC, Vs) ~> messageDone </k>
		<messagequeue>
			ListItem(
				MC:Method,
				Vs:Values
			) => .
			...
		</messagequeue>

/* ************************************************************************** */

	rule
		<k> send ( messageClosure('_`(_`)(M:Method,, Vs:Values)) ) ; => schedule(M, Vs) ... </k>
	/*
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
	*/

/* ************************************************************************** */

endmodule
