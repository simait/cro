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

			<store> .Map </store>
			<nextLoc> 0 </nextLoc>
		</T>

end module