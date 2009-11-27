function map = maps(varargin)
% Chebfun maps
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
%  MAPPARAMS is a row vector containing the  paramaters which define the
%  map.
%  Examples;
%    chebfun(@(x) sin(1000*x), 'map', {'kte',.9});
%    chebfun(@(x) 1 + (1-x).^sqrt(3), 'map', {'sing',[1 sqrt(3)]});
%    chebfun(@(x) tanh(100*pi*x/2), 'map', {'slit',1i/100});
%  (A keen user might want to compare the lengths of these chebfuns with
%  those not using maps!)
%
%  Users can also create their own maps ...
%
%  This function also acts as a gateway to return map structures, with
%    MAP = MAPS({MAPNAME,MAPPARAMS},INT);
%  where INT is 2 by 1 vector containing the images of -1 and 1 under the
%  map. INT may also be a domain object, of if it is not given then assumed
%  to be [-1,1].

%  map = maps({'kte',.9},[0,1]);


map = maps(fun,varargin{:});