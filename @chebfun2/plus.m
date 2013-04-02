function h = plus ( f, g )
%+	  Plus.
%
% F + G adds chebfun2s F and G, or a scalar to a chebfun2 if either F or G
% is a scalar.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if isempty(f) || isempty(g)  % check for empty chebfun2
   h = chebfun2;  % just return an empty chebfun2. 
   return; 
end

% quick check for zero chebfun2 objects. 
if ( isa(f,'chebfun2') && norm(f.fun2.U) == 0 ) 
    h = g; return;
end

if ( isa(g,'chebfun2') && norm(g.fun2.U) == 0 ) 
    h = f; return;
end



if ( isa(f,'chebfun2') && isa(g,'double') )  
%% chebfun2 + double
    if isempty(f) % check for empty chebfun2.
        return
    end
    h = f;
    h.scl = f.scl;
    h.fun2 = plus(f.fun2,g);
elseif ( isa(f,'double') && isa(g,'chebfun2') )  
%% double + chebfun2
    if isempty(g) % check for empty chebfun2.
        return
    end
    h = g;
    h.scl = g.scl;
    h.fun2 = plus(f,g.fun2);
elseif ( isa(f,'chebfun2') && isa(g,'chebfun2') )  
%% chebfun2 + chebfun2
    if isempty(g) % check for empty chebfun2.
        h = f; return
    end
    if isempty(f) % check for empty chebfun2.
        h = g; return
    end
    h = f;
    h.scl = f.scl;
    h.fun2 = plus(f.fun2,g.fun2);
    
    % Add the derivatives. Need to make sure they have the correct dimensions.
    fderiv = f.deriv;
    gderiv = g.deriv;
    
    % Obtain the dimensions of the derivatives of the inputs.
    [mf, nf] = size(fderiv);
    [mg, ng] = size(gderiv);
    
    % The final derivative will have the dimensions corresponding to the maximum
    % dimensions of the input derivatives. We create an all zero matrix of that
    % dimensions, then add the old derivative information to the bottom right of
    % that matrix
    newDeriv = zeros(max(mf,mg),max(nf,ng));
    fderivNew = newDeriv;
    gderivNew = newDeriv;
    
    % Replace entries of the matrices of the correct size with information from
    % the input variables.
    fderivNew(end-mf+1:end,end-nf+1:end) = fderiv;
    gderivNew(end-mg+1:end,end-ng+1:end) = gderiv;
    
    % Add the two derivative matrices together, and assign to the deriv field of
    % the output variable.
    h.deriv = fderivNew + gderivNew;
else
    error('CHEBFUN2:plus:type','Cannot add these two objects together');
end

end