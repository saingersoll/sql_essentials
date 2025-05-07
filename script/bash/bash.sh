# terminal work


# the number of lines in a file
wc -l <filename>
wc -l ASDN_Bird_nests.csv 
#  this tells you lines of each and sums total lines
wc -l *.csv

#  define variable name
name="Sofia"
# false check
echo name
#  real check
echo $name

# global variable
$PATH

# check python
which python
which -a python

# check shell
which $SHELL
which -a $SHELL


# get date
date
# save as a variable
today=$(date)
# check
echo $today


# double paranthesis to compute
echo $((2+4))

# using duckdb
# we can replace duckdb with python and r
# we can program bash to program the indices overnight
duckdb -csv database.db "SELECT Code, Common_name FROM Species"