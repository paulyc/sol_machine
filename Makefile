compile: contracts/*.sol contracts/machine/*.sol test/*.sol
	solc --allow-paths ${CURDIR}/contracts,${CURDIR}/contracts/machine,${CURDIR}/test,${CURDIR}/test/machine **/*.sol
