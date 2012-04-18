in cro-common
in cro-syntax

module CRO-CONFIG imports CRO-COMMON + CRO-SYNTAX

	syntax K ::= "loadedProgram" "(" K ")"

	configuration
		<T>
			<k> loadedProgram($PGM:K) </k>
			<env> .Map </env>
			<error> "" </error>
			<parseStack> .K </parseStack>
// 			<currentTask> "" </currentTask>
// 			<parseNS> #id(""),.Strings </parseNS>
// 			<currentContext> "file",.Strings </currentContext>
		</T>

end module