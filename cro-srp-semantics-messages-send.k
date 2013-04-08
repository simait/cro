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
require "cro-srp-schedule.k"

/* ************************************************************************** */

module CRO-SRP-SEMANTIC-MESSAGES-SEND

	imports CRO-SRP-SYNTAX
	imports CRO-SRP-CONFIG
	imports CRO-SRP-SCHEDULE
	imports CRO-CORE-SEMANTIC-MESSAGES


/* ************************************************************************** */

	rule
		send
			P:Priority E:Exp ; =>
			messageClosureCreate(E) ~> send P HOLE ;		[heat]

/* ************************************************************************** */

	rule
		MC:MessageClosure ~> send P:Priority HOLE ; => send P MC ;	[cool]

/* ************************************************************************** */

	rule
		send MC:MessageClosure ; => send priority(1) MC ;		[anywhere]

/* ************************************************************************** */

	rule
		<k>
			send priority(P:Int) MC:MessageClosure ; ~> Cont:K =>
			schedule(P, MC, Cont)
		</k>

/* ************************************************************************** */

	rule
		<k>
			messageDone =>
			schedule()
		</k>

/* ************************************************************************** */

endmodule
