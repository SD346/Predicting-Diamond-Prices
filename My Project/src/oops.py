class Operators:
    
    def add_one(self,x):
        return x+1
    
    def sub_one(self,x):
        return x-1
    
    def mul_one(self,x):
        return x*1
    
    def div_one(self,x):
        return x/1
    
    def op_one(self):
        print("Doing some math")

d = Operators()

print(d.div_one(4))
print(d.add_one(6))
print(type(d))