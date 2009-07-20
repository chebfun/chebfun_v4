function public_struct = struct(g)
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

names = fieldnames(g);
values = cell(length(names), numel(g(:)));
for k = 1:length(names)
    [values{k,:}] = subsref(g(:), substruct('.', names{k}));
end
public_struct = reshape(cell2struct(values,names,1),size(g));