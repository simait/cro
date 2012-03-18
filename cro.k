in cro-syntax

module CRO imports CRO-SYNTAX

	syntax KResult ::= #Int

	configuration
		<T>
			<k> $PGM:K </k>
		</T>

	rule I:#Id \. I
end module