function A = oparray(varargin)
% OPARRAY   Array of function handles.
% The OPARRAY class is a support class for chebop that implements arrays of
% function handles, together with matrix-style transformations and
% combinations of them. It helps chebops maintain "infinite-dimensional"
% implementations of themselves. 

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

% This is the only field. It is always a cell, even in the 1x1 case.
A.op = {};

if nargin==0
elseif isa(varargin{1},'oparray')
  A = varargin{1};
  return
elseif nargin==1
  if iscell(varargin{1})
    A.op = varargin{1};
  else
    A.op = { varargin{1} };
  end
end

A = class(A,'oparray');

end