/*
 * This file is part of CRO-EXTENDED-K.
 *
 * Copyright (C) 2012 Simon Aittamaa <simon.aittamaa@ltu.se>.
 *
 * CRO-EXTENDED-K is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CRO-EXTENDED-K is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CRO-EXTENDED-K.  If not, see <http://www.gnu.org/licenses/>.
 */

require "cro-core-syntax.k"

module CRO-EXTENDED-SYNTAX

	imports CRO-CORE-SYNTAX

	syntax Exp ::=
		"(" Exp ")"							[bracket]
		| "-" Exp							[strict]
		> left:
			Exp "*" Exp						[strict, left]
		| Exp "/" Exp							[strict, left]
		| Exp "%" Exp							[strict, left]
		> left:
			Exp "+" Exp						[strict, left]
		| Exp "-" Exp							[strict, left]
		> non-assoc:
			Exp "<" Exp						[strict, non-assoc]
		| Exp "<=" Exp							[strict, non-assoc]
		| Exp ">" Exp							[strict, non-assoc]
		| Exp ">=" Exp							[strict, non-assoc]
		| Exp "==" Exp							[strict, non-assoc]
		| Exp "!=" Exp							[strict, non-assoc]
		> "not" Exp							[strict]
		> left:
			Exp "and" Exp						[strict, left]
		| Exp "or" Exp							[strict, left]

	syntax Cmd ::=
		"if" "(" Exp ")" Cmd						[strict(1)]
		| "if" "(" Exp ")" Cmd "else" Cmd				[strict(1)]
		| "while" "(" Exp ")" Cmd

endmodule