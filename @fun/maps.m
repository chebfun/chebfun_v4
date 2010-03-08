function map = maps(fun,varargin)
% Maps
%  This function allows you to call the maps which are buried in
%  @fun/private. It will not usually be called directly by the user, 
%  but rather by its sister function maps.m in the trunk.

if length(varargin) == 1,
    varargin = {varargin};
    ends = chebfunpref('domain');
else
    ends = varargin{2};
    if isnumeric(ends) && length(ends) == 1
        if length(varargin) == 3, 
            ends = varargin{3};
            varargin(3) = [];
        else
            ends = chebfunpref('domain');
        end
    else
        varargin(2) = [];
    end
    if isa(ends,'domain')
        ends = ends.ends;
    else
        ends = ends(:).';
    end
end

v1 = varargin{1};
if isstruct(v1)
    mapname = v1.name;
    pars = v1.par(3:end);
elseif iscell(v1)
    mapname = v1{1};
    if numel(v1) == 2
        pars = v1{2}(:).';
    else
        pars = []; 
    end    
else
    mapname = v1;
    if length(varargin) > 2
        pars = varargin(:).';
    else
        pars = []; 
    end  
end

map = feval(mapname,[ends pars]);
