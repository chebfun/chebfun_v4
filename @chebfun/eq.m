function F = eq(f,g)

h = sign(f-g);
F = (h.funs{1}==0);