function A = varmat(defn)
% VARMAT  Variable-sized matrix object constructor.
% V = VARMAT(FUN) creates a variable-sized matrix object based on the
% function FUN. FUN should be a function of one argument N and return a
% matrix of size NxN. 
%
% VARMATs support arithmetic and referencing (slicing). It is mostly
% intended as a support class for CHEBOP and therefore is lightly
% documented. It may become inaccessible in future chebop releases.
%
% See also CHEBOP.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

A.defn = [];
A.rowsel = [];
A.colsel = [];

if nargin==0
elseif isa(defn,'varmat')
  A = defn;
  return
elseif isa(defn,'function_handle')
  A.defn = defn;
else
  error('VARMAT:varmat:fail','Varmat failed')
end
 
A = class(A,'varmat');

