#!/usr/bin/env wish

# vim: set fileencoding=utf-8 :
#
# Βασίλης Αλεξάνδρου, STOIXHMA.TCL, 13/2/2006
# ξαναγράψιμο στις 10/Μαΐου/2006
# Το πρώτο μου πρόγραμμα σε tcl/tk
#

# Set window title
wm title . {στοίχημα (2η έκδ) - 2006}
wm deiconify . ;# put window in front

set initial 3000; # αρχική μπάνκα
set ngames 100; # πλήθος αγώνων
#set yield 45; # απόδοση αγωνα
#set prob 75; # συνολική πιθανότητα επιτυχίας
#set bet 10; # ποσοστό στοιχήματος επί της μπάνκας

set WIDTH 30

proc ValidDouble {val} {
	expr {[string is double $val] || [string match {[-+]} $val]}
}

# frames, labels and entries
foreach {label text} { \
			initial {Αρχική Μπάνκα}\
			ngames {Πλήθος Παιχνιδιών} \
			yield {Απόδοση Αγώνων} \
			prob {Πιθανότητα Κέρδους (0-100%)} \
			bet {Ποσοστό Πονταρίσματος (0-100%)}} {
	frame .$label -borderwidth 1
	pack .$label -side top -fill x

	label .$label.l -text $text -anchor w -width $WIDTH \
							-font {tahoma 14 bold}
	entry .$label.e -width 10 -textvariable $label -relief sunken \
			-justify right -validate all -vcmd {ValidDouble %P} \
			-font {tahoma 14 bold}

	pack .$label.l -side left
	pack .$label.e -side left -fill x -expand true
}

# ποσοστό επιτυχίας & τελικό ποσό
frame .final -borderwidth 1
pack .final -side top -fill x
label .final.l2 -text {Τελική Μπάνκα} -anchor w -width $WIDTH -font {tahoma 16 bold}
label .final.r2 -text {ευρώ} -anchor w -width 5 -font {tahoma 16 bold}
entry .final.e2 -width 10 -textvariable final -relief sunken \
				-justify right -font {tahoma 16 bold}
pack .final.l2 -side left
pack .final.e2 -side left -fill x -expand true
pack .final.r2 -side left

focus .initial.e
bind .bet.e <Return> {Calc $initial $ngames $yield $prob $bet}

##############################################################

proc Calc {initial ngames yield prob bet} {
	global final

	#set yield [expr {$yield / 100.0}]
	set yield [expr {$yield - 1.0}]
	set prob [expr {$prob / 100.0}]
	set bet [expr {$bet / 100.0}]
	set wins [expr {pow(1 + $yield * $bet, $prob * $ngames)}]
	set losses [expr {pow(1 - $bet, $ngames * (1 - $prob))}]
	set final [format "%g" [expr {$initial * $wins * $losses}]]
	#unset final
}

# setup vim: set filetype=tcl ts=8 sw=8 sts=8 ai sta noet:
