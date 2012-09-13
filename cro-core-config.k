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

require "cro-core-syntax.k"

module CRO-CORE-CONFIG

	imports CRO-CORE-SYNTAX

	syntax K ::= "programLoaded" "(" K ")"

// 	syntax ListItem ::= "(" Bag "," Map ")"

// 	syntax CellLabel ::= "classes" | "class" | "name" | "params" | "declarations"

// 	syntax Value ::= "nothing"
// 	syntax Context ::= "(" Int "," Map ")"
// 	syntax Contexts ::= List{Context, ","}


	configuration
		<T>
// 			<k> loadedProgram($PGM:Module) </k>
// 			<root> loadedProgram($PGM:K) </root>
			<messages>
				<message multiplicity="*">
					<k> programLoaded($PGM:K) </k>
// 					<uid> 0 </uid>
// 					<baseline> 0 </baseline>
// 					<env> .Map </env>
					<contexts> .List </contexts>
// 					<objStack> .List </objStack>
// 					<environmentStack> .List </environmentStack>
				</message>
			</messages>

// 			<br/>
// 			<nextUID> 1 </nextUID>
// 			<br/>
//
// 			<time> 0 </time>
// 			<postponed> .List </postponed>
// 			<br/>
//
			<classes>
// 				<class multiplicity="*">
// 					<name> "" </name>
// 					<params> .List </params>
// 					<declarations> .List </declarations>
// 				</class>
				.Map
			</classes>
// 			<br/>

// 			<parseStack> .List </parseStack>
// 			<classStack> .List </classStack>
// 			<br> </br>
// 			<br/>
// 			<classStackItem>
// 				<className> #id("") </className>
// 				<classEnv> .Map </classEnv>
// 				<classInterface> .Map </classInterface>
// 				<locked> false </locked>
// 				<location> 0 </location>
// 			</classStackItem>
// 			<br/>
//
// 			<input stream="stdin"> $IN:List </input>
// 			<output stream="stdout"> .List </output>
// 			<br/>
//
// 			<events> .List </events>

			<store> .Map </store>
			<nextLocation> 0 </nextLocation>
		</T>

endmodule