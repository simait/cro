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

module CRO-CORE-CONFIG

	syntax K ::= "programLoaded" "(" K ")"

	configuration
		<T color="brown">
			<messages color="orange">
				<message multiplicity="*" color="yellow">
					<k color="green"> programLoaded($PGM:K) </k>
					<contexts color="magenta"> .List </contexts>
				</message>
			</messages>

			<classes color="purple">
				.Map
			</classes>

			<class>
				<interface> .Map </interface>
				<bindings> .Map </bindings>
				<state> .Map </state>
				<active> false </active>
			</class>

			<method>
				<object> O:Value </object>
				<params> Is:Ids </params>
				<commands> Cs:Cmds </commands>
			</method>

			<store color="blue"> .Map </store>
			<nextLocation color="red"> 0 </nextLocation>
		</T>

endmodule