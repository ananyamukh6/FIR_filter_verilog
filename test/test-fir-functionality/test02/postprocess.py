#golden output

lines = open('out_temp.txt').readlines()
f = open('out.txt', 'w')
			
lastline = lines[-1]


f.write(str(lastline))
f.close()
