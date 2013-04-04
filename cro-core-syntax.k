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

module CRO-CORE-SYNTAX

	// "root" and "init" are a part of all programs (for now...)
	syntax Id ::= "root" | "init"

	syntax Ids ::= List{Id, ","}

	// Expressions, still needs work to get precedence "right".
	syntax Exp ::=
		Value
		| Id
		| Exp "." Id
		| Exp "(" Exps ")"						[strict]

	syntax Exps ::= List{Exp, ","}						[strict]

	syntax Cmd ::=
		"{" "}"
		| "{" Cmds "}"
		| Decl
		| Exp ";"							[strict]
		| Exp ":=" Exp ";"						[strict(2)]
		| "send" Exp ";"
		| "return" Exp ";"						[strict]
		| "halt" ";"

	syntax Cmds ::=
		Cmd
		| Cmds Cmds							[right]

	syntax Decl ::= Id "=" "new" Id "(" Exps ")" ";"
	syntax Decl ::= "var" Exp ":=" Value ";"
	syntax Decl ::= "method" Id "(" Ids ")" Cmd

	syntax Decl ::= "class" Id "(" Exps ")" Cmd

	syntax Value ::=
		Int
		| Bool
		| String
		| "nothing"
	syntax Values ::= List{Value, ","}

	//Module definition, should be top level but no way to enforce this?
	syntax Module ::= "module" Id Cmd

	// Make things easier to write semantics for...
	rule	method I:Id (Is:Ids) {} => method I (Is) {return nothing;}	[structural]

	// Make sure we don't have any empty { }
	rule	{ } => { nothing; }						[structural]

	// Ensure that we have sequential execution of Cmds.
	rule	C0:Cmds C1:Cmds => C0 ~> C1					[structural]

endmodule