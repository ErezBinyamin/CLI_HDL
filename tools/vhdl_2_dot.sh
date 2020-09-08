#!/bin/bash
# -- get_dep_list --
DEP_LIST=()
get_dep_list() {
	cd $1
	for d in `ls -d ./*/ 2>/dev/null`
	do
		get_dep_list $d
	done
        DEP_LIST+=(`ls ${PWD}/*.vhd`)
	cd ..
}

get_port_map() {
	INPUT_COLOR=green
	OUTPUT_COLOR=red
	printf '
// https://renenyffenegger.ch/notes/tools/Graphviz/examples/index\n\n
digraph D {
	//default
	rankdir="LR";
	graph [splines=ortho, nodesep=.01, ranksep=3]
	edge [arrowhead=none]
	'
	for f in ${DEP_LIST[@]}
	do
		unset INPUTS OUTPUTS PORT_MAP

		# Parse out entity name (should match filename) and Extract port map
		ENTITY=`basename $f | sed 's/\..*//'`
		PORT_MAP=`grep -A 1000 "entity $ENTITY is" $f | grep -m 1 -B 1000 '    );' | grep ':'`

		# Parse out input/ouput signals to create entity ports
                # Inputs
		echo "$PORT_MAP" | grep ' in '  | tr -d ' ; ' | sed 's/:in/,/'> /tmp/map
		while read line
		do
			SIG=`echo "$line" | cut -d ',' -f 1`
			INPUTS+="\n\t\t\t\t\t<tr><td port=\'${SIG}\'> ${SIG} </td></tr>"
		done < /tmp/map
		# Outputs
		NUM_OUT=0
                echo "$PORT_MAP" | grep ' out ' | tr -d ' ;'  | sed 's/:out/,/' > /tmp/map
		while read line
		do
			SIG=`echo "$line" | cut -d ',' -f 1`
			OUTPUTS+="\n\t\t\t\t\t<tr><td port=\'${SIG}\'> ${SIG} </td></tr>"
		done < /tmp/map

		# Draw entity node
		printf "\t//NODE -- $ENTITY\n\t$ENTITY [shape=plaintext, label=<
		<table border='1' cellborder='0' cellspacing='0'>
			<tr><td>$ENTITY</td></tr>
			<tr>
				<td><table border='0' cellborder='1' cellspacing='0' color=\'${INPUT_COLOR}\'>$INPUTS
				</table></td>
				<td><table border='0' cellborder='1' cellspacing='0' color=\'${OUTPUT_COLOR}\'>$OUTPUTS
				</table></td>
			</tr>
		</table> >]\n\n"
	done
	printf "}\n"
}

# -- MAIN --
get_dep_list work
get_port_map
