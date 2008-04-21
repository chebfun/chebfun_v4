function Fout = horzcat(varargin)
% HORZCAT   Chebfun vertical concatenation.
%   [F1 F2] is the vertical concatenation of chebfun quasi-matrices F1 and F2.
%
%   For row chebfuns, F = HORZCAT(F1,F2,...) concatenates any number
%   of chebfuns by translating their domains to, in effect, create a
%   piecewise defined chebfun F.
%
%   For column chebfuns, F = VERTCAT(F1,F2,...) returns a quasi-matrix whose
%   columns are F1, F2, ....
%
%   See also CHEBFUN/VERTCAT, CHEBFUN/SUBSASGN.
%

% Chebfun Version 2.0

Fout =  varargin{1}';
for k = 2:nargin
    Fout = vertcat(Fout, varargin{k}');
end
Fout = Fout';