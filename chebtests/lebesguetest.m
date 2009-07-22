function pass = lebesguetest

tol = chebfunpref('eps');
[L,C] = lebesgue(chebpts(3));
pass1 = abs(C-5/4)<10*tol;
[L,C] = lebesgue(legpts(3),[-1,1]);
pass2 = abs(C-7/3)<10*tol;
[L,C] = lebesgue(linspace(5,9,3),5,9);
pass3 = abs(C-5/4)<10*tol;
L = lebesgue([1 2],domain([0,7]));
pass4 = abs(norm(L,inf)-11)<10*tol;
pass = pass1 && pass2 && pass3;
