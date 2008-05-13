function out = subsref(varargin)
% Fun SUBSREF just call the built-in SUBSREF.

out = builtin('subsref',varargin{:});
