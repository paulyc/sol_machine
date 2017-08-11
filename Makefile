compile: *.sol test/*.sol
	solc --allow-paths ${CURDIR} **/*.sol
