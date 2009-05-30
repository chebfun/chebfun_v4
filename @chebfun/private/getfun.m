function [g, hpy, scl] = getfun(op, interval, maxn, scl, pref)
% [G, HPY, SCL] = GETFUN(OP, INTERVAL, MAXN, SCL)
%   GETFUN returns a fun with length at most MAXN with respect to the
%   horizonta and vertical scales in SCL (SCL.H and SCL.V).
%
%   HPY is true if the length of G is smaller than MAXN, meaning that the
%   fun constructor was able to prune some coefficients in this process.
%
%   The structure SCL gets uptdate within this function and is returned as
%   an output.
%
%   PREF is the chebfun preference structure (see chebfunpref).
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:


% Initial setup
htol = 1e-14*scl.h;
a = interval(1); b = interval(2);
funscl = scl;
funscl.h = scl.h*2/(b-a);

% If the interval is very small skeep adaptation  and return a constant
% This should never be happen, though!
if (b-a) < 2*htol
    g = fun(op((b+a)/2));
    scl.v=max(scl.v,g.scl.v);
    g=set(g,'scl.v',scl.v);
    hpy = true;
    %warning('CHEBFUN:getfun:SmallInterval','Small interval, fun might be unhappy')
else

    if ~(pref.splitting) % In splitting OFF mode, use values at end points
        % get fun!
        g = fun(@(x) op(.5*((b-a)*x+b+a)), maxn, funscl, pref);

    else % In splitting ON mode, decide whether extrapolate values to the boundary

        % Get values at the boundary and close to it.
        vne = op([a, a+htol, a+2*htol, b-2*htol, b-htol, b]');
        funscl.v = max(funscl.v,norm(vne,inf));
        
        % Check for NaN's or Inf's
        if any(isnan(vne)) || any(isinf(vne))
            error('CHEBFUN:getfun:naneval','Function returned NaN or Inf when evaluated.')
        end
        
        if abs(vne(1)-vne(2)) <= 10*abs(vne(3)-vne(2))
            va = vne(1);                 % Extrapolation at x=a is not needed
        else
            va = 2*vne(2)-vne(3);        % Extrapolate to the left
        end
        if abs(vne(6)-vne(5)) <= 10*abs(vne(5)-vne(4))
            vb = vne(6);                 % Extrapolation at x=b is not needed
        else
            vb = 2*vne(5)-vne(4);        % Extrapolate to the right
        end

        % get fun!
        g = fun(@(x) eval_op(x,op,va,vb,a,b), maxn, funscl, pref);

    end

    hpy = (length(g) < maxn);     % Check happiness.
    scl.v = g.scl.v;              % Update the vertical scale.

end

% -------------------------------------------------------------------------
function y = eval_op(x,op,va,vb,a,b)
% Extrapolation.

y= op(.5*((b-a)*x(2:end-1)+b+a));
y = [va; y; vb];