compile: contracts/*.sol test/*.sol
	solc --allow-paths ${CURDIR}/contracts,${CURDIR}/test **/*.sol

compile-bin: contracts/*.sol test/*.sol
	solc --allow-paths ${CURDIR}/contracts,${CURDIR}/test --bin **/*.sol

compile-abi: contracts/*.sol test/*.sol
	solc --allow-paths ${CURDIR}/contracts,${CURDIR}/test --abi **/*.sol
