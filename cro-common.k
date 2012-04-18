in cro-syntax

module CRO-COMMON imports CRO-SYNTAX

	syntax Ids ::= List{#Id, ","}
	syntax Decls ::= List{Decl, ","}
	syntax Strings ::= List{#String, ","}

	kvar NS I	: #Id
	kvar T		: Type
	kvar E		: Exp
	kvar Es		: Exps
	
	declare types : Exps -> Types
	define types(.Exps)		=> void,.Types
	define types(I : T, .Exps)	=> T,.Types
	define types(I : T, E, Es)	=> T, types(E, Es)

	declare ids : Exps -> Ids
	define ids(.Exps)		=> .Ids
	define ids(I : T, .Exps)	=> I, .Ids
	define ids(I : T, E, Es)	=> I, ids(E, Es)

	declare qId : #Id #Id -> #Id
	define qId(NS, I)		=> #id(Id2String(NS) +String "::" +String Id2String(I))

	declare ns : #Id -> #Id
	define ns(#id(""))		=> #id("")
	define ns(I)			=> #id(substrString(Id2String(I), rfindString(Id2String(I), "::", 0), lengthString(Id2String(I))))

end module