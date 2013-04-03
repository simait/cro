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

require "cro-core-semantic.k"

/* ************************************************************************** */

require "cro-srp-config.k"

/* ************************************************************************** */

module CRO-SRP-SEMANTIC-OBJECTS-ACTIVATE

	imports CRO-CORE-SEMANTIC-OBJECTS

/* ************************************************************************** */

	imports CRO-SRP-CONFIG

/* ************************************************************************** */

	rule
		<k> objectActivate(locationValue(L:Int)) => . ... </k>
		<systemceiling> (. => ListItem(OC:Int)) ListItem(CC:Int) ... </systemceiling>
		<store>
			...
				L |-> objectClosure(
					<active> false => true </active>
					<ceiling> OC </ceiling>
					_:Bag
				)
			...
		</store>
		/*when (CC <Int OC)*/						[transition]

/* ************************************************************************** */

	rule
		<k> objectDeactivate(locationValue(L:Int)) => . ... </k>
		<systemceiling> (ListItem(CC:Int) => .) ... </systemceiling>
		<store>
			...
				L |-> objectClosure(
					<active> true => false </active>
					_:Bag
				)
			...
		</store>							[transition]

/* ************************************************************************** */

endmodule