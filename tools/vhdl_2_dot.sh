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
	for f in ${DEP_LIST[@]}
	do
		ENTITY=`basename $f | sed 's/\..*//'`
		MAP=`grep -A 1000 "entity $ENTITY is" $f | grep -m 1 -B 1000 '    );' | grep ':'`
		echo '----------'
		echo $ENTITY
                # Inputs
		echo "$MAP" | grep ' in '  | tr -d ' ; ' | sed 's/:in/,/'> /tmp/map
		while read line
		do
			printf " --> "
			echo "$line" | cut -d ',' -f 1
		done < /tmp/map
		# Outputs
                echo "$MAP" | grep ' out ' | tr -d ' ;'  | sed 's/:out/,/' > /tmp/map
		while read line
		do
			printf " <-- "
			echo "$line" | cut -d ',' -f 1
		done < /tmp/map
	done
}

# -- MAIN --
get_dep_list work
get_port_map
