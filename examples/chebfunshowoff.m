format long
clear all
clc
% Define a function with poles at x=-1 and x=1
F=chebfun(@(x) exp(sin(14*x))./(1-x)./(1+x));
% plot it
plot(F)
ylim([0 20])
%%
% differentiate the fuand plot the derivative
f =diff(F);
plot(f)
ylim([-100 100])
%%
% define a function with a square root blowup at x=-1
p=chebfun(@(x) cos(40*x)./sqrt(1+x),'splitting','on');
plot(p)
ylim([-10 10])
% compute the machine-precision accurate integral
sum(p)
%%
% another function with a blowup at x=0. This time we pass the locations of
% the interval endpoints as a second argument
q = chebfun(@(x) cos(4*pi*x)./sqrt(abs(x)),[-1 0 1]);
plot(q)
ylim([-10 30])
% again, we have a finite intergal which can be easily computed
sum(q)
%% this doesn't seem to work
% % we can combine these chebfuns as usual using the binary operations
% t = p+q;
% plot(t)
% ylim([-10 20])
% sum(t)
%% nor this
% r=chebfun(@(x) tan(pi*x/2),'splitting','on')
% plot(r)
% ylim([-10,10])    
%% chebyshev coefficients
% show that obtaining chebyshev coefficients by evaluating the integral 
% formula gives the same results as those obtained via chebpoly 
clc
f=@(x) exp(cos(8*x));
n=30;               % number of coeffs to compare

ff=chebfun(f);
a=chebpoly(ff)';
if n<=length(a)
    a=a(end-n+1:end);
end

aa=zeros(n,1);
tic
for i=1:n
    T = chebpoly(i-1);
    GG=chebfun(@(x) f(x).*T(x)./sqrt(1-x.^2));
    if i~=1
        aa(n-i+1)=2*sum(GG)/pi;
    else
        display('     chebpoly coeff        chebfun sum            error ')       
        display(' i        a(i)                aa(i)            a(i)-aa(i)')    
        fprintf('\n')
        aa(n-i+1)=sum(GG)/pi;
    end
    fprintf('%2d  %+9.15f  %+9.15f  %+9.15f\n',i-1,a(n-i+1),aa(n-i+1),a(n-i+1)-aa(n-i+1))
end
toc
%% Test the 'diff' operator for arbitrary functions
x1=[-1:0.05:-0.5]'; x2=[-0.45:0.05:0]'; x3=[0.05:0.05:0.5]'; x4=[0.55:0.05:1]';

while true

    s = input('Enter function  (single quotes), F(x) = ');

    clc
    sdiff=sym2str(diff(s));

    s = strrep(s, '^','.^');
    s = strrep(s, '/','./');
    s = strrep(s, '*','.*');
    eval(['F=@(x) ' s ';'])
    eval(['f=@(x) ' sdiff ';'])
    FF=chebfun(F)
    ff=diff(FF)

    disp('                         -1 < x < -0.5')
    disp([f(x1) ff(x1) f(x1)-ff(x1)])
    disp('                       -0.5 < x < 0')
    disp([f(x2) ff(x2) f(x2)-ff(x2)])
    disp('                          0 < x < 0.5')
    disp([f(x3) ff(x3) f(x3)-ff(x3)])
    disp('                        0.5 < x < 1')
    disp([f(x4) ff(x4) f(x4)-ff(x4)])
    
    %plot(ff), hold on, plot(FF,'r'), hold off
    
end