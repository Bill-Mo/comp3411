from math import log2

def entropy(n, ni, pi):
	p1 = 1
	p2 = 1
	if pi != 0:
		p1 = pi/(pi+ni)
	if ni != 0:
		p2 = ni/(pi+ni)
	h = -p1*log2(p1)-p2*log2(p2)
	h = (pi+ni)/(n)*h
	return h

if __name__ == '__main__':
	ip = 'a'
	sum = 0
	while ip != '':
		ip = input("Total number, true, false: ")
		if ip != '':
			n, ni, pi = (ip.split())
			print(entropy(int(n), int(ni), int(pi)))
			sum = sum + entropy(int(n), int(ni), int(pi))
	print(sum)