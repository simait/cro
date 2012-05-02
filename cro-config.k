/*
 * This file is part of CRO-EXEC.
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
in cro-common
in cro-syntax

module CRO-CONFIG imports CRO-COMMON + CRO-SYNTAX

	syntax K ::= "loadedProgram" "(" K ")"

	configuration
		<T>
			<messages>
				<message multiplicity="*">
					<k> loadedProgram($PGM:K) </k>
					<uid> 0 </uid>
					<env> .Map </env>
					<objStack> .List </objStack>
					<envStack> .List </envStack>
				</message>
			</messages>
			<br/>
			<nextUID> 1 </nextUID>
			<br/>

			<classes>
				<class multiplicity="*">
					<name> #id("") </name>
					<params> .List </params>
					<declarations> .List </declarations>
				</class>
			</classes>
			<br/>

			<classStack> .List </classStack>
			<br/>
			<classStackItem>
				<thisClass> #id("") </thisClass>
				<classEnv> .Map </classEnv>
				<classInterface> .Map </classInterface>
				<locked> false </locked>
				<location> 0 </location>
			</classStackItem>
			<br/>

			<input stream="stdin"> $IN:List </input>
			<output stream="stdout"> .List </output>
			<br/>

			<events> .List </events>

			<store> .Map </store>
			<nextLoc> 0 </nextLoc>
		</T>

end module