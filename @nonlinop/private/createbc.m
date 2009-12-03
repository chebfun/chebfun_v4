function bcOut = createbc(bcArg)
% CREATEBC Converts various types of allowed BC syntax to correct form.

if strcmp(bcArg,'neumann')
    bcOut = @(u) diff(u);
elseif strcmp(bcArg,'dirichlet')
    bcOut = @(u) u;
elseif isnumeric(bcArg)
    val = bcArg;
    bcOut = @(u) u-val;
elseif iscell(bcArg) % BC-s of the form {1, @(u)diff(u)};
    % Need to convert the doubles to anonymous functions.
    bcOut = cell2anon_fun(bcArg);
else
    bcOut = bcArg;
end

end