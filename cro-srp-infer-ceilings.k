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

require "cro-core-config.k"
require "cro-core-init.k"

module CRO-SRP-INFER-CEILINGS

	imports CRO-CORE-CONFIG
	imports CRO-CORE-INIT

/* ************************************************************************** */

	syntax K ::= "inferSRP"

/* ************************************************************************** */

	rule <k> inferSRP => . ... </k>

/* ************************************************************************** */

	rule
		<store>
			...
			_:Int |-> (
				objectClosure(
						<interface> I:Map </interface>
						<bindings> B:Map </bindings>
						<state> S:Map </state>
						<active> A:Bool </active>
				) =>
				objectClosure(
						<interface> I </interface>
						<bindings> B </bindings>
						<state> S </state>
						<active> A </active>
						<ceiling> 1 </ceiling>
				)
			)
		</store>

/* ************************************************************************** */

endmodule