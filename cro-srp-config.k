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
require "cro-srp-semantics-messages-send.k"

/* ************************************************************************** */

module CRO-SRP-CONFIG

	imports CRO-CORE-CONFIG
	imports CRO-SRP-SEMANTIC-MESSAGES-SEND

/* ************************************************************************** */

	configuration
		<T>
			<messages>
				<message multiplicity="*" color="yellow">
					<k color="green"> programLoaded($PGM:K) </k>
					<contexts color="magenta"> .List </contexts>
				</message>
			</messages>

			<maxmessages> 1 </maxmessages>
			<messagequeue> .List </messagequeue>

			<br/>

			<store color="red"> .Map </store>
			<nextLocation color="blue"> 0 </nextLocation>

			<classes color="purple">
				.Map
			</classes>

			<br/>

			<systemceiling> ListItem(0) .List </systemceiling>
			<systempriority> ListItem(0) .List </systempriority>

			<ceiling> 0 </ceiling>
		</T>

/* ************************************************************************** */

endmodule