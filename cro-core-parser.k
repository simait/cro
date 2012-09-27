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

require "cro-core-syntax.k"

module CRO-CORE-PARSER

	imports CRO-CORE-SYNTAX

	syntax K ::= "programParse" "(" K ")" | "parseCleanup"

	syntax K ::= "class" "(" Ids "," Cmds ")"

/* ************************************************************************** */

	rule
		<k> programParse(P:K) => P ... </k>

	rule
		<k> parseCleanup => . ... </k>
		<classes>
			Clss:Map => .
		</classes>

	rule
		<k> module I:Id {Cs:Cmds} => Cs ... </k>

	rule
		<k> class I:Id (Is:Ids) {Cs:Cmds} => . ... </k>
		<classes> (. => I |-> class (Is, Cs)) Rho:Map </classes>
		when notBool(I in keys(Rho))

endmodule