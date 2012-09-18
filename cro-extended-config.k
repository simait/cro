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

module CRO-EXTENDED-CONFIG

	syntax K ::= "programLoaded" "(" K ")"

	configuration
		<T>
			<messages>
				<message multiplicity="*" color="yellow">
					<k color="green"> programLoaded($PGM:K) </k>
					<contexts color="magenta"> .List </contexts>
				</message>
			</messages>

			<classes color="purple">
				.Map
			</classes>

			<store color="red"> .Map </store>
			<nextLocation color="blue"> 0 </nextLocation>

			<input stream="stdin"> $IN:List </input>
			<output stream="stdout"> .List </output>

		</T>

endmodule