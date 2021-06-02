# mysqlpump.exe.ghidra.csv.filtered: mysqlpump.exe.ghidra.csv
# 	echo $< $@
# 	awk -F, '$$3 == "\"CONSTRUCTOR\"" || $$3 == "\"DESTRUCTOR\"" || $$3 == "\"INDETERMINATE\"" {print}' $< > $@

.PHONY: all
all: mysqlpump.ghidra.constructors mysqlpump.ghidra.destructors

mysqlpump.ghidra.constructors: mysqlpump.exe.ghidra.csv
	awk -F, '$$3 == "\"CONSTRUCTOR\"" { print $$4 }' $< > $@

mysqlpump.ghidra.destructors: mysqlpump.exe.ghidra.csv
	awk -F, '$$3 == "\"DESTRUCTOR\"" { print $$4 }' $< > $@
