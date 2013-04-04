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

require "cro-core-syntax.k"

/* ************************************************************************** */

module CRO-SRP-SYNTAX

	imports CRO-CORE-SYNTAX

/* ************************************************************************** */

/*
	syntax Time ::=
		"sec" "(" Int ")"
		| "msec" "(" Int ")"
		| "usec" "(" Int ")"
*/

/* ************************************************************************** */

/*
	syntax TimeConstraint ::=
		"before" Time
		| "after" Time
*/

/* ************************************************************************** */

	syntax Priority ::=
		"priority" "(" Int ")"

/* ************************************************************************** */

	syntax Ceiling ::=
		"ceiling" "(" Int ")"

/* ************************************************************************** */

/*
	syntax Cmd ::=
		"send" TimeConstraint Exp ";"
		| "send" TimeConstraint TimeConstraint Exp ";"
		| "send" Priority Exp ";"
*/
	syntax Cmd ::=
		"send" Priority Exp ";"

	syntax Decl ::=
		Id "=" "new" Ceiling Id "(" Exps ")" ";"

/* ************************************************************************** */

endmodule
