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

require "cro-core-config.k"
require "cro-core-semantic.k"

/* ************************************************************************** */

module CRO-CORE-SCHEDULE

	imports CRO-CORE-CONFIG
	imports CRO-CORE-SEMANTIC-MESSAGES

/* ************************************************************************** */

	syntax K ::= "schedule" "(" Cmds ")"


/* ************************************************************************** */

	syntax K ::= "sizeBag" "(" Bag "," Int ")"				[function]
	rule sizeBag(.Bag, I:Int) => I
	rule sizeBag(_:BagItem B:Bag, I:Int) => sizeBag(B, I +Int 1)

/* ************************************************************************** */

	syntax K ::= "sizeBag" "(" Bag ")"					[function]
	rule sizeBag(B:Bag) => sizeBag(B, 0)

/* ************************************************************************** */

	rule
		<messages>
			<message>
				<k>
					schedule(Cs:Cmds) => .
					...
				</k>
				...
			</message>
			(. =>
			<message>
				<k> Cs ~> messageDone </k>
				<contexts> .List </contexts>
			</message>
			)
			...
		</messages>
		<maxmessages> MM:Int </maxmessages>
		when MM ==Int 0							[transition]

/* ************************************************************************** */

	rule
		<messages>
			<message>
				<k>
					schedule(Cs:Cmds) => .
					...
				</k>
				...
			</message>
			(. =>
			<message>
				<k> Cs ~> messageDone </k>
				<contexts> .List </contexts>
			</message>
			)
			Ms:Bag
		</messages>
		<maxmessages> MM:Int </maxmessages>
		when (MM =/=Int 0) andBool ((sizeBag(Ms) +Int 1) <Int MM)	[transition]

/* ************************************************************************** */

	rule
		<messages>
			<message>
				<k>
					schedule(Cs:Cmds) => .
					...
				</k>
				...
			</message>
			Ms:Bag
		</messages>
		<maxmessages> MM:Int </maxmessages>
		<messagequeue> ... (. => ListItem(Cs)) </messagequeue>
		when (MM =/=Int 0) andBool ((sizeBag(Ms) +Int 1) >=Int MM)	[transition]

/* ************************************************************************** */

	rule
		<messages>
			<message>
				<k>
					messageDone => (Cs:Cmds ~> messageDone)
				</k>
				...
			</message>
			...
		</messages>
		<messagequeue> ListItem(Cs) => . ... </messagequeue>		[transition]

/* ************************************************************************** */

endmodule