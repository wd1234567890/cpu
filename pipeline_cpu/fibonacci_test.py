def f(n):
    if n == 1 :
        sum = 1
    elif n == 2 :
        sum = 2
    else :
        sum = f(n-1) + f(n-2)
    return sum

for n in range(1,1000):
    if f(n) >= 0x8b44a657 :
        print(n)
        print(hex(f(n)))
        break