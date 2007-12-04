function [f,converged] = fixedgrow(op,ends)
% FIXEDGROW Constructs a fun f for the function defined by the function
% handle op on the interval [ends(1), ends(2)].  A fun corresponds to a
% single global polynomial interpolant through data in Chebyshev points,
% i.e., a "classic" chebfun as in the original chebfun system by Zachary
% Battles.  The maximum number of Chebyshev points is 2^16.  If the
% function is successfully  resolved, a fun f is returned of appropriate
% length with converged=1.  If the function is not resolved, a fun f of
% length 2^16 is returned with converged=0, and a warning message is issued.

% The design of this code is slightly intricate because of the
% desire to get high accuracy while still producing chebfuns of minimal
% appropriate length.  We have settled on a two-step process.  First,
% a decision is made of whether the "tail" of the Chebyshev series
% is small enough that f has been successfully captured.  If not,
% we double the number of points and try again.  If so, a rather
% delicate choice is made of exactly where to truncate the series.  
% This program is the product of a good deal of testing and it should
% not be modified lightly.
% Rodrigo has found a bug in this, which LNT will fix.

% Nick Trefethen, November 2007

f = fun;                               % start with an empty fun
for n = 2.^(2:16)                      % try increasing values of n
   v = op(cheb(n,ends(1),ends(2)));    % function vals at scaled Cheb pts
   f = set(f,'val',v,'n',n);           % set values and number of pts
   c = funpoly(f);                     % coeffs of Cheb expansion of f
   ac = abs(c)/norm(v,inf);            % abs value relative to scale of f
   Tlen = max(3,n/8);                  % length of tail to test
   Tmax = 2e-16*Tlen^(2/3);            % maximum permitted size of tail
   if max(ac(1:Tlen)) < Tmax           % we have converged; now chop tail
      Tend = min(find(ac>=Tmax))-1;    % pos of last entry below Tmax
      ac = ac(1:Tend); ac(1) = 5e-17;   
      for i = 2:Tend                   % compute the cumulative max of
         ac(i) = max(ac(i),ac(i-1));   %   the tail entries and 5e-17
      end
      Tbpb = log(1000*Tmax./ac)./ ...
         (length(c)-(1:Tend));         % bang/buck of chopping at each pos
      [foo,Tchop] = max(Tbpb(3:Tend)); % Tchop = pos at which to chop
      f = fun(c(Tchop+3:end));         % chop the tail
      converged = 1;                   % successful termination
      return
   end
end
converged = 0;                          % unsuccessful termination
warning('Function not resolved, using 2^16 pts. Have you tried ''splitting on''?');
