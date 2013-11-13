#!/usr/bin/awk -f

# 20090616 v0.10 initial version
# 20090616 v0.11 now handles correctly macroexpansion of single letter parameters
# 20090616 v0.15 can now include files
# 20090616 v0.20 if the name of the parameter in macrocall is the same with that in macrodefinition
#                it doesn't go on with the replacement
# 20090616 v0.30 add support for multiline macrodefinitions
# 20090616 v0.35 using the -I switch you can specify a list of dirs to search for included files

# me: macroexpansion
BEGIN {
	PROG = "me"

	for (i = 1; i < ARGC; i++) { # i know i should use getopt
		if (ARGV[i] ~ /^-h/)
			usage(0)
		else if (ARGV[i] ~ /^-I/) {
			incdirs = ARGV[i + 1]
			ARGV[i] = ARGV[i + 1] = ""
		} else if (ARGV[i] ~ /^-/)
			usage(1)
	}

	dbg("cwd `" ENVIRON["PWD"] "'")
	NINC = split(incdirs, INC, /,/)
	for (i = 1; i <= NINC; i++)
		dbg("include dir `" INC[i] "'")

	SEP = sprintf("%c", 0) # a character to separate multiline macrodefinitions
	if (!DIRSEP) DIRSEP = "/"
}

{ clearinput() } # fucking dos

#include file
match($0, /^#include[ \t]+"([^"]+)"$/, a) > 0 {
	dbg("file to be included `" a[1] "'")
	cat(a[1])
	next
}

# simple definition
match($0, /^#define[ \t]+([[:alpha:]_][[:alnum:]_]*)[ \t]+(.*)$/, a) > 0 {
	dbg("definition = `" a[1] "', subst = `" a[2] "'")
	DEFS[a[1]] = a[2]
	next
}

# complex definition
match($0, /^#define[ \t]+([[:alpha:]_][[:alnum:]_]*)\(([^)]+)\)[ \t]+(.*)$/, a) > 0 {
	if ($0 !~ /\\$/) { # macro expansion in one line
		dbg("definition = `" a[1] "', params = `" a[2] "', prog = `" a[3] "'")
		DEFS[a[1]] = a[3]
		PARAMS[a[1]] = a[2]
		next
	}

	dbg("definition = `" a[1] "', params = `" a[2] "'")
	PARAMS[a[1]] = a[2]
	collectdef = a[3]
	sub(/\\$/, SEP, collectdef)

	while (getline > 0) {
		clearinput()
		dbg("getlined: " $0)

		# XXX: clean up this
		if ($0 !~ /\\$/) {
			sub(/\\$/, SEP, $0)
			collectdef = collectdef $0
			break
		} else {
			sub(/\\$/, SEP, $0)
			collectdef = collectdef $0
		}
	}

	dbg("multiline def: `" collectdef "'")
	DEFS[a[1]] = collectdef
	next
}

# here we will be expanding any macros found
{
	if (!match($0, /@([^@]+)@/, a)) { # nothing to expand
		if (!D) print
		next
	}

	# collect stuff before and after the macro call
	# XXX: how can we accomodate multiple macro calls on the same line?
	before = substr($0, 1, RSTART - 1)
	after = substr($0, RSTART + RLENGTH)

	fullmatch = a[0]
	macro = a[1]
	dbg("macro `" macro "'")
	name = getmacroname(macro)
	dbg("name `" name "'")

	if (!(name in DEFS))
		error("no definition for `" name "'.", 1)

	if (macro !~ /\(/) { # handle easy case first
		sub(fullmatch, DEFS[name], $0)
		print
		next # we're done
	}

	# so, we've got parameters for the macro
	expa = getexpansion(name)
	nparam = getparams(name, params)
	narg = getmacroargs(macro, args)
	dbg("nparam = " nparam " narg = " narg)

	if (narg != nparam)
		error("macro `" name "' called with different number of arguments than defined.", 1)

	rest = expa
	for (i = 1; i <= nparam; i++) {
		dbg(i " -> " params[i] " -> " args[i])

		if (params[i] == args[i]) # XXX: think about this better, maybe it's too smart
			continue

		tobematched = "\\W(" params[i] ")\\W" # XXX: danger, will robinson! see below
		dbg("tobematched `" tobematched "'")

		while (match(rest, tobematched, spam) > 0) {
			dbg("rest `" rest "'")
			dbg("params[" i "] = `" params[i] "'")

			if (rest !~ params[i])
				break

			dbg("spam[1] = `" spam[1] "'")
			sub("\\<" spam[1] "\\>", args[i], rest) # XXX: something's gotta give
		}
	}

	gsub(SEP, "\n", rest)
	print before rest after
}

function findfile(filename,	i, file, line) {
	for (i = 1; i <= NINC; i++) {
		file = INC[i] DIRSEP filename
		dbg("findfile `" file "'")

		if ((getline line < file) > 0) {
			close(file)
			return file
		}
	}

	return ""
}

function cat(filename,	ff, line) {
	if (!(ff = findfile(filename)))
		error("could not find file `" filename "' to include.", 1)

	if (!D)
		while ((getline line < ff) > 0)
			print line

	close(ff)
}

function getmacroname(macro,	array) {
	match(macro, /([[:alpha:]_][[:alnum:]_]+)/, array)
	return array[1]
}

# XXX: really sloppy
function getmacroargs(macro, args,	array) {
	match(macro, /\(([^)]+)\)/, array)
	dbg("getmacroargs for " array[1])
	return split(array[1], args, ", ")
}

function getparams(def, params) {
	delete params
	return split(PARAMS[def], params, ", ")
}

function getexpansion(macroname) { return DEFS[macroname] }

function clearinput() { sub(/\r\n$/, "\n", $0) }

function dbg(msg) { if (D) printf "%s:%d: %s\n", FILENAME, FNR, msg > "/dev/stderr" }
function error(msg, quit) { printf "%s:%d:error: %s\n", FILENAME, FNR, msg > "/dev/stderr"; if (quit) exit 1 }

function usage(exit_code) {
	printf "%s: usage: %s [options] infile\n", PROG, PROG > "/dev/stderr"
	printf "%s: simple & simplistic macro expansion\n", PROG > "/dev/stderr"
	print "Options:" > "/dev/stderr"
	print "  -v name=value\t\tset variable `NAME' to value `VALUE' (awk switch)" > "/dev/stderr"
	print "  -v D=1\t\tset debug mode on (awk switch)" > "/dev/stderr"
	print "  -I dir1,dir2,...\tcomma separated list of" > "/dev/stderr"
	print "\t\t\tdirectories to search for included files" > "/dev/stderr"
	print "  -h\t\t\tshow this help message and exit" > "/dev/stderr"
	exit exit_code
}
