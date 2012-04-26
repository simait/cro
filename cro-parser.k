in cro-config
in cro-common
in cro-syntax

module CRO-PARSER imports CRO-COMMON + CRO-SYNTAX + CRO-CONFIG

	syntax K ::= "parseProgram" "(" K ")" | "parseCleanup"

	kvar I				: Id
	kvar Es				: Exps
	kvar Ss				: Stmts
	kvar Clss			: Bag
	kvar P				: K

/* ************************************************************************** */

	rule
		<k> parseProgram(P) => P ... </k>

	rule
		<k> parseCleanup => . ... </k>
		<classes>
			Clss => .
		</classes>

	rule
		<k> module I {Ss} => Ss ... </k>

	rule
		<k> class I (Es) {Ss} => . ... </k>
		<classes>
			(. => <class>
				<name> I </name>
				<params> ids(Es) </params>
				<declarations> Ss </declarations>
			</class>)
			...
		</classes>

end module