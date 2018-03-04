# title: Exploring Julia DB
# author: Pavan Gurazada

using JuliaDB


"""
Exploring Tablesin JuliaFB
"""
# Step 1: Creating tables
x = [false, true, false, true]
y = ['B', 'B', 'A', 'A']
z = [0.1, 0.3, 0.2, 0.4]

table(x, y, z) # By default there are no column names
t1 = table(x, y, z, names = [:x, :y, :z])
t2 = table(x, y, z, names = [:x, :y, :z], pkey = (:x, :y)) # Sorted by primary key

# Step 2: Accessing data from tables

t2[1] # Returns a named tuple of the first row, since it is stored that way

t2[1].z

# Iteration over rows

for row in t2
    println(row)
end

oscars = loadtable("oscars.csv")
oscars[1500].Year

# Select works by specifying the column numbers or the column name symbol

select(oscars, :Year)
select(oscars, 1)

# Multiple selections return a table

select(oscars, (1, :Year))

# columns can be selected and passed on to functions for evaluation

colnames(oscars)
