function [g, hpy, scl] = getfun(op, interval, pref, scl)
% [G, HPY, SCL] = GETFUN(OP, INTERVAL, PREF, SCL)
%   GETFUN returns a fun for OP. INTERVAL is the doamin. PREF the
%   preference structure and SCL the scale structure -- horizonta and #
%    vertical scales in SCL (SCL.H and SCL.V).
%
%   The structure SCL gets uptdate within this function and is returned as
%   an output.
%
%   HPY is true if the coefficients

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

% Initial setup
htol = 1e-14*scl.h;
a = interval(1); b = interval(2);

% If the interval is very small skeep adaptation  and return a constant
% This should never be happen, though!
if (b-a) < 2*htol
    g = fun(op((b+a)/2),[a b]);
    scl.v=max(scl.v,g.scl.v);
    g=set(g,'scl.v',scl.v);
    hpy = true;
    %warning('CHEBFUN:getfun:SmallInterval','Small interval, fun might be unhappy')
else

    if ~pref.splitting || (isinf(a) && isinf(b))
        % In splitting OFF mode, use values at end points
        % get fun!
        g = fun(@(x) op(x), [a b], pref, scl);
        
    else
        
        % Get values at the boundary and close to it.
        vne = op([a, a+htol, a+2*htol, b-2*htol, b-htol, b]');
        
        if isinf(b) % Only check the left end-point.
            
            % Check for NaN's or Inf's
            if any(isnan(vne(1))) || any(isinf(vne(1)))
                error('CHEBFUN:getfun:naneval','Function returned NaN or Inf when evaluated.')
            end
            
            if abs(vne(1)-vne(2))<=10*abs(vne(3)-vne(2))
                va = vne(1);                 % Extrapolation at x=a is not needed
            else
                va = 2*vne(2)-vne(3);        % Extrapolate to the left
            end
            
            % get fun!
            g = fun(@(x) [va;op(x(2:end))], [a b], pref, scl);
            
        elseif isinf(a) % Only check the right end-point.
            
             % Check for NaN's or Inf's
            if any(isnan(vne(6))) || any(isinf(vne(6)))
                error('CHEBFUN:getfun:naneval','Function returned NaN or Inf when evaluated.')
            end
            
            if abs(vne(6)-vne(5))<=10*abs(vne(4)-vne(5))
                vb = vne(6);                 % Extrapolation at x=b is not needed
            else
                vb = 2*vne(5)-vne(4);        % Extrapolate to the right
            end
            
            % get fun!
            g = fun(@(x) [op(x(1:end-1));vb], [a b], pref, scl);

            
        else % In splitting ON mode, decide whether extrapolate values to the boundary
            
            % Check for NaN's or Inf's
            if any(isnan(vne)) || any(isinf(vne))
                error('CHEBFUN:getfun:naneval','Function returned NaN or Inf when evaluated.')
            end
            
            if abs(vne(1)-vne(2))<=10*abs(vne(3)-vne(2))
                va = vne(1);                 % Extrapolation at x=a is not needed
            else
                va = 2*vne(2)-vne(3);        % Extrapolate to the left
            end
            if abs(vne(6)-vne(5))<=10*abs(vne(4)-vne(5))
                vb = vne(6);                 % Extrapolation at x=b is not needed
            else
                vb = 2*vne(5)-vne(4);        % Extrapolate to the right
            end
            
            % get fun!
            g = fun(@(x) [va;op(x(2:end-1));vb], [a b], pref, scl);
            
        end
    end
    
    % Check happiness.
    if pref.splitting
        hpy = (g.n < pref.splitdegree+1);   
    else
        hpy = (g.n < pref.maxdegree+1); 
    end
    
    scl.v = g.scl.v;              % Update the vertical scale.
    
end