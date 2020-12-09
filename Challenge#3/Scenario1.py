#Scenario 1: If some undefined variable is given in the dictionary which is not present, below code will skip the undefined Varibale and check for next variable.

#taking the dictionary into cont variable
cont = {"x":{"y":{"z":"a"}}}
#Validating with key
key = "john/x"
#using split function to separate the keys and using it for further iterations
new_key = key.split("/")
#looping the separated key with the dictionary 
for item in new_key:
#checking if the given key present in the dictionary
    if item in cont:
        cont = cont[item]
#printing the dictionary based on the key check.
print cont