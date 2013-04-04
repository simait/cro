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

require "cro-core-init.k"
require "cro-srp-syntax.k"

/* ************************************************************************** */

module CRO-SRP-INIT

	imports CRO-CORE-INIT
	imports CRO-SRP-SYNTAX


/* ************************************************************************** */

	syntax K ::=
		"objectCeilingSet" "(" Int "," LocationValue ")"		[strict(2)]

/* ************************************************************************** */

	rule
		<k> objectCeilingSet(C:Int, locationValue(L:Int)) => locationValue(L) ... </k>
		<store>
			...
			L |-> objectClosure(
					(. => <ceiling> C </ceiling>)
					_:Bag
				)
			...
		</store>

/* ************************************************************************** */

	rule
		<k> I:Id = new ceiling(OC:Int) C:Id (Vs:Values); => objectBindAdd(I, objectCeilingSet(OC, objectCreate(C, Vs))) ... </k>

/* ************************************************************************** */

	syntax K ::= "programInitSRP"

/* ************************************************************************** */

	rule
		<k> programInitSRP => contextsInit(objectCeilingSet(1, objectCreate(root, .Values))) ... </k>

/* ************************************************************************** */

endmodule