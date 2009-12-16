function map = maps(varargin)
% CHEBFUN MAPS
%  Rather than using Chebyshev polynomial interpolants, chebfun can use
%  non-polynomial bases defined by maps. This is useful in a number of
%  circumstances, such as when working on infinite intervals, or with 
%  functions which are ill-behaved in localised regions of the interval.
%
%  The syntax for creating a chebfun using a map is
%    chebfun(@(x) f(x), 'map', {MAPNAME,MAPPARAMS});
%  where MAPNAME is a one of;
%    'LINEAR','UNBOUNDED','SING','KTE','STRIP','SAUSAGE',
%    'SLIT','SLITP', or 'MPINCH'. 
%  MAPPARAMS is a row vector containing the paramaters which define the map.
%  (An overview of some of the important maps is given below.)
%  Examples;
%    chebfun(@(x) sin(1000*x), 'map', {'kte',.9});
%    chebfun(@(x) 1 + (1-x).^sqrt(3), 'map', {'sing',[1 sqrt(3)]});
%    chebfun(@(x) tanh(100*pi*x/2), 'map', {'slit',1i/100});
%  (A keen user might want to compare the lengths of these chebfuns with
%  those not using maps!)
%
%  This function also acts as a gateway to return map structures, with
%    MAP = MAPS({MAPNAME,MAPPARAMS},INT);
%  where INT is 2 by 1 vector containing the images of -1 and 1 under the
%  map. INT may also be a domain object, of if it is not given then assumed
%  to be [-1,1].
%
%  The LINEAR map is simply a linear scaling and is all the time in chebfun
%  when working on an interval other than [-1,1]. It does not contain and
%  tunable parameters.
%
%  The UNBOUNDED map is for unbounded domains of the form [-inf,b],
%  [-inf,inf], or [a,inf]. For semi-infinite domains (here with infinity 
%  at the right boundary), this map takes the form 
%     m(y) = 15*s*(y+1)./(1-y)+a
%  where S is a scaling parameter that can be changed. By defaults it is
%  taken from mappref.parinf(1).
%  On doubly infinite domains the maps takes the form
%     m(y) = 5*s*y./(1-y.^2)+c
%  where again S is a scaling and C is a shift. These are also taken by
%  default from mappref.parinf(1:2) respectively if not supplied.
%
%  The SING map is for dealing with functions with singular endpoints that
%  cannot be dealt wf = chebfun('(1-x.^2).^.3','singmap',[.3 .3])ith with 'exps'. 
%  SINGmaps take two parameters, which correspond to the form of singularity 
%  at the left and right ends of the interval respectively. Zero (0) or one (1) 
%  corresponds to no singlarity. For example
%     m = maps({'sing',[.5,1]})
%  will be a good map for dealing with something like f(x) = sqrt(x)+1
%  Currently if singularites are required at the end, the parameter can
%  only be [.5 .5] or [.25 .25], yet such a map can still do well even when
%  these exponents aren't exactly correct. For example
%     m = maps({'sing',[.25 .25]},[-2 -2)
%     f = chebfun('(4-x.^2).^.3',[-2 2],m)
%  SING type maps can be called directly in the constructor via
%     f = chebfun('(4-x.^2).^.3',[-2 2],'singmap',[.25 .25])

map = maps(fun,varargin{:});
