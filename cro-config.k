in cro-common
in cro-syntax

module CRO-CONFIG imports CRO-COMMON + CRO-SYNTAX

	syntax K ::= "loadedProgram" "(" K ")"

	configuration
		<T>
			<k> loadedProgram($PGM:K) </k>
			<uid> 0 </uid>
			<env> .Map </env>
			<envStack> .List </envStack>
			<classStack> .List </classStack>
			<this>
				<thisClass multiplicity="?"> #id("") </thisClass>
				<classEnv multiplicity="?"> .Map </classEnv>
				<location multiplicity="?"> 0 </location>
			</this>
			<classes>
				<class multiplicity="*">
					<name> #id("") </name>
					<params> .List </params>
					<declarations> .List </declarations>
				</class>
			</classes>
			<error> "" </error>
			<program> .K </program>
			<parseStack> .K </parseStack>
			<store> .Map </store>
			<nextLoc> 0 </nextLoc>
			<nextUID> 0 </nextUID>
		</T>

end module