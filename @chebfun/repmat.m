function Fout = repmat(F,M,N) 
%REPMAT   Replicate and tile a chebfun.
%    Fout = REPMAT(F,M,N) creates a large chebfun quasimatrix Fout 
%    consisting of tiling of copies of F.
%    If F is a column quasimatrix, then REPMAT(F,1,N) returns a
%    quasimatrix with N*size(F,2) chebfun columns. If F consists of row
%    chebfuns, REPMAT(F,M,1) returns a quasimatrix with M*size(F,1).
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if nargin < 2
    error('CHEBFUN:repmat:NotEnoughInputs', 'Requires 3 inputs.')
end

Fout = F;
if F(1).trans 
    if N>1
        error('Use REPMAT(F,M,1) to replicate and tile row chebfuns')
    else
        for j = 2:M, Fout = [ Fout; F ];  end
    end
else 
    if M>1
        error('Use REPMAT(F,1,N) to replicate and tile column chebfuns')
    else
        for j = 2:N, Fout = [Fout F];  end 
    end
end