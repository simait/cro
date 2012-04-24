in cro-syntax

module CRO-COMMON imports CRO-SYNTAX

	syntax Ids	::= List{Id, ","}
	syntax Strings	::= List{String, ","}

	kvar NS I	: Id
	kvar T		: Type
	kvar E		: Exp
	kvar Es		: Exps

	syntax Types ::= "types" "(" Exps ")"			[function klabel(types)]
	define types(.Exps)		=> .Types
	define types(I : T, .Exps)	=> T,.Types
	define types(I : T, E, Es)	=> T, types(E, Es)

	syntax Ids ::= "ids" "(" Exps ")"			[function klabel(ids)]
	define ids(.Exps)		=> .Ids
	define ids(I : T, .Exps)	=> I, .Ids
	define ids(I : T, E, Es)	=> I, ids(E, Es)

// 	declare qId : #Id #Id -> #Id
// 	define qId(NS, I)		=> #id(Id2String(NS) +String "::" +String Id2String(I))
// 
// 	declare ns : #Id -> #Id
// // 	define ns(#id(""))		=> #id("")
// 	define ns(I)			=> #id(substrString(Id2String(I), rfindString(Id2String(I), "::", 0), lengthString(Id2String(I))))

end module