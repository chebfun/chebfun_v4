%% NONNORMALITY QUIZ FROM TREFETHEN AND EMBREE
% Nick Trefethen, 11 October 2010

%%
% (Chebfun example linalg/NonnormalQuiz.m)

%%
% The frontispiece of the book Spectra and Pseudospctra
% presents a Quiz involving two matrices:
A1 = [-1 1; 0 -1],  A2 = [-1 5; 0 -2]

%%
% The quiz shows the following plot of norms of
% exponentials exp(tA) of these matrices as functions of t:
e1 = chebfun(@(t) norm(expm(t*A1)),[0 3.4],'vectorize');
e2 = chebfun(@(t) norm(expm(t*A2)),[0 3.4],'vectorize');
LW = 'linewidth'; FS = 'fontsize';
hold off, plot(e1,'b',LW,2)
hold on,  plot(e2,'r',LW,2)
ylim([0 1.5]), grid on, legend('A1','A2')
xlabel('t',FS,14)
ylabel('||e^{tA}||',FS,14)
title('Which curve is which?',FS,16)

%%
% The book asks "Which curve is which?", and doesn't reveal the
% answer, but here you can see which is which.  One might expect
% the "hump" to correspond to the matrix with a defective eigenvalue,
% but in fact it comes from the matrix with the large entry 5 in
% the upper-right corner.

%%
% Reference:
%
% L. N. Trefethen and M. Embree, Spectra and Pseudospectra: The Behavior
% of Nonnormal Matrices and Operators, Princeton U. Press, 2005.
