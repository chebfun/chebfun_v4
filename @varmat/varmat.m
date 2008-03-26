function A = varmat(defn)

A.defn = [];
A.rowsel = [];
A.colsel = [];

if isa(defn,'varmat')
  A = defn;
elseif isa(defn,'function_handle')
  A.defn = defn;
else
  error('failed')
end
 
A = class(A,'varmat');

