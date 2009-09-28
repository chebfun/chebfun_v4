function map = maps(fun,varargin)
% Maps
%  This function allows you to call the maps which are buried in
%  @fun/private. It will not usually be called directly by the user, 
%  but rather by its sister function maps.m in the trunk.

if length(varargin) == 1,
    ends = [-1 1];
else
    ends = varargin{2};
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
else
    mapname = v1{1};
    pars = v1{2}(:).';
end

map = feval(mapname,[ends pars]);
