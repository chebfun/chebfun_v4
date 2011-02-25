function bcOut = createbc(bcArg)
% CREATEBC Converts various types of allowed BC syntax to correct form.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if strcmp(bcArg,'neumann')
    bcOut = @(u) diff(u);
elseif strcmp(bcArg,'dirichlet')
    bcOut = @(u) u;
elseif ~isempty(bcArg) && isnumeric(bcArg)
    val = bcArg;
    bcOut = @(u) u-val;
elseif iscell(bcArg) % BC-s of the form {1, @(u)diff(u)};
    % Need to convert the doubles to anonymous functions.
    bcOut = cellfun(@createbc,bcArg,'uniform',false);
else
    % If we get here, only option left is a BC already on the an. function
    % form or a empty variable, so we simply use that.
    bcOut = bcArg;
end

end