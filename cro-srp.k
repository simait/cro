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
require "cro-core-config.k"
require "cro-core-parser.k"
require "cro-core-semantic.k"
require "cro-core-init.k"

/* ************************************************************************** */

require "cro-srp-config.k"
require "cro-srp-infer-ceilings.k"
require "cro-srp-semantic-objects-activate.k"
require "cro-srp-semantics-messages-send.k"

/* ************************************************************************** */

module CRO-SRP

	imports CRO-SRP-CONFIG
	imports CRO-SRP-SEMANTIC-OBJECTS-ACTIVATE
	imports CRO-SRP-SEMANTIC-MESSAGES-SEND
	imports CRO-SRP-INFER-CEILINGS
	
/* ************************************************************************** */

	imports CRO-CORE-CONFIG
	imports CRO-CORE-SYNTAX
	imports CRO-CORE-PARSER
	imports CRO-CORE-SEMANTIC
	imports CRO-CORE-INIT

/* ************************************************************************** */

	rule
		<k> programLoaded(P:K) => programParse(P) ~> programInit ~> inferSRP ~> programEval </k>	[transition]

/* ************************************************************************** */

endmodule