#!/bin/bash
DEP_LIST=()
get_dep_list() {
	cd $1
	for d in `ls -d ./*/ 2>/dev/null`
	do
		get_dep_list $d
	done
    for f in `ls *.vhd`
    do
        DEP_LIST+=(${PWD}/$f)
    done
	cd ..
}
get_dep_list work
echo ${DEP_LIST[@]}
