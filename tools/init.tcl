# Inspired from: https://gist.github.com/davidzwa/ef1eafc6cd23e613af612e27eddb054b
set nsigs [ gtkwave::getNumFacs ]
set sigs [list]
# fix a strange bug where addSignalsFromList doesn't seem to work
# if the 1st signal to be added is not a single bit
lappend sigs "__bug_marker__"

# Add non uut signals to design
for {set i 0} {$i < $nsigs} {incr i} {
    set signame [ gtkwave::getFacName $i ]
    set index1 [ string first "uut" $signame  ]
    if {$index1 == -1} {
        lappend sigs $signame
	puts $signame
    }
}
set added [ gtkwave::addSignalsFromList $sigs ]

# Zoom
gtkwave::/Time/Zoom/Zoom_Full

# Show decimal values
gtkwave::/Edit/Highlight_All
gtkwave::/Edit/Data_Format/Signed_Decimal
