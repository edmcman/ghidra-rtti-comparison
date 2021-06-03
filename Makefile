# mysqlpump.exe.ghidra.csv.filtered: mysqlpump.exe.ghidra.csv
# 	echo $< $@
# 	awk -F, '$$3 == "\"CONSTRUCTOR\"" || $$3 == "\"DESTRUCTOR\"" || $$3 == "\"INDETERMINATE\"" {print}' $< > $@

.PHONY: all

#all: mysqlpump.ghidra.constructors mysqlpump.ghidra.destructors mysqlpump.ooanalyzer.constructors mysqlpump.ooanalyzer.destructors mysqlpump.ground.constructors mysqlpump.ground.destructors

all: mysqlpump.ghidra-only.constructors

mysqlpump.ground.constructors: mysqlpump.exe.ground
	cat $< | python3 parse-ground.py constructor 0 | sort -n > $@

mysqlpump.ground.destructors: mysqlpump.exe.ground
	cat $< | python3 parse-ground.py [a-z]+Destructor 0 | sort -n > $@

mysqlpump.ghidra.constructors: mysqlpump.exe.ghidra.csv
	awk -F, '$$3 == "\"CONSTRUCTOR\"" { print $$4 }' $<  | tr -d '"' | python3 -c 'import sys; [print(hex(int(x, 16)),) for x in sys.stdin]' | sort -n > $@

mysqlpump.ghidra.destructors: mysqlpump.exe.ghidra.csv
	awk -F, '$$3 == "\"DESTRUCTOR\"" { print $$4 }' $< | tr -d '"' | python3 -c 'import sys; [print(hex(int(x, 16)),) for x in sys.stdin]' | sort -n > $@

mysqlpump.ooanalyzer.constructors: mysqlpump.exe.results
	cat $< | python3 parse-ground.py constructor 1 | sort -n > $@

mysqlpump.ooanalyzer.destructors: mysqlpump.exe.results
	cat $< | python3 parse-ground.py [a-z]+Destructor 1 | sort -n > $@

mysqlpump.ghidra.constructors.correct: mysqlpump.ghidra.constructors mysqlpump.ground.constructors
	comm -12 $^ > $@

mysqlpump.ooanalyzer.constructors.correct: mysqlpump.ooanalyzer.constructors mysqlpump.ground.constructors
	comm -12 $^ > $@

mysqlpump.ghidra-only.constructors: mysqlpump.ghidra.constructors.correct mysqlpump.ooanalyzer.constructors.correct
	comm -23 $^ > $@
