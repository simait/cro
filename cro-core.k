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
require "cro-core-config.k"
require "cro-core-parser.k"
require "cro-core-semantic.k"
require "cro-core-init.k"

module CRO-CORE
	imports CRO-CORE-CONFIG
	imports CRO-CORE-SYNTAX
	imports CRO-CORE-PARSER
	imports CRO-CORE-SEMANTIC
	imports CRO-CORE-SEMANTIC-OBJECTS-ACTIVATE
	imports CRO-CORE-SEMANTIC-MESSAGES-SEND
	imports CRO-CORE-INIT

	rule
		<k> programLoaded(P:K) => programParse(P) ~> programInit ~> programEval </k>	[transition]

endmodule