function F = horzcat(f,g)
%HORZCAT Horizontal concatenation of chebfun2 objects.
% 
%  This is not allowed and returns an error.  This function exists so that
%  the error message is meaningful to a Chebfun2 user. 

error('CHEBFUN2:HORZCAT','Horizontal concatenation of chebfun2 objects is not supported.')

end