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

in cro-syntax

module CRO-COMMON imports CRO-SYNTAX

	syntax Ids	::= List{Id, ","}
	syntax Strings	::= List{String, ","}

	kvar I		: Id
	kvar T		: Type
	kvar E		: Exp
	kvar Es		: Exps

	syntax Types ::= "types" "(" Exps ")"			[function klabel(types)]
	define types(.Exps)		=> .Types
	define types(I : T, .Exps)	=> T,.Types
	define types(I : T, E, Es)	=> T, types(E, Es)

	syntax Ids ::= "ids" "(" Exps ")"			[function klabel(ids)]
	define ids(.Exps)		=> .Ids
	define ids(I : T, .Exps)	=> I, .Ids
	define ids(I : T, E, Es)	=> I, ids(E, Es)

end module