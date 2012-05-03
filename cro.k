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
in cro-common
in cro-syntax
in cro-config
in cro-parser
in cro-semantic

module CRO imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG + CRO-PARSER + CRO-SEMANTIC

	kvar S1 S2		: Stmts
	kvar P			: K

	// Ensure sequential execution of commands.
	rule	S1 S2 => S1 ~> S2														[structural]

	//@ First rule, the loded program is in the <k> cell, we "lift" it and start the process of parsing and validating.
	rule
		<k> loadedProgram(P) => parseProgram(P) ~> initProgram ~> executeProgram </k>

end module