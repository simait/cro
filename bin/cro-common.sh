function executeOK {
	grep --silent 'executeDone' $1
	return $?
}