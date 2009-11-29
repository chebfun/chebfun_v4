% orrsomm.m  Eigenvalues of Orr-Sommerfeld operator

[d,x] = domain(-1,1);
I = eye(d); D = diff(d);
Re = input('Reynolds no. (e.g. 5772)? '); alpha = 1.02;
B = D^2 - alpha^2;
A = B^2/Re - 1i*alpha*(2+diag(1-x.^2)*B);
A.lbc(1) = I; A.lbc(2) = D;
A.rbc(1) = I; A.rbc(2) = D;
e = eigs(A,B,50,'LR');
maxe = max(real(e));
plot(e,'.r'), grid on, axis([-.9 .1 -1 0]), axis square
title(['Re = ' sprintf('%5d',Re) ...
   ',   \lambda_r = ' sprintf('%7.5f',maxe)],'fontsize',16)
shg
