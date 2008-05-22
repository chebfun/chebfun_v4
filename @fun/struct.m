function public_struct = struct(g)

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

names = fieldnames(g);
values = cell(length(names), numel(g(:)));
for k = 1:length(names)
    [values{k,:}] = subsref(g(:), substruct('.', names{k}));
end
public_struct = reshape(cell2struct(values,names,1),size(g));