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
in cro-config
in cro-common
in cro-syntax

module CRO-PARSER imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG

	syntax K ::= "parseProgram" "(" K ")" | "parseCleanup"

	kvar I				: Id
	kvar Es				: Exps
	kvar Ss				: Stmts
	kvar Clss			: Bag
	kvar P				: K

/* ************************************************************************** */

	rule
		<k> parseProgram(P) => P ... </k>

	rule
		<k> parseCleanup => . ... </k>
		<classes>
			Clss => .
		</classes>

	rule
		<k> module I {Ss} => Ss ... </k>

	rule
		<k> class I (Es) {Ss} => . ... </k>
		<classes>
			(. => <class>
				<name> I </name>
				<params> ids(Es) </params>
				<declarations> Ss </declarations>
			</class>)
			...
		</classes>

end module