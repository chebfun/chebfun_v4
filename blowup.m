function blowup(on_off)
%BLOWUP     CHEBFUN blowup option
%   BLOWUP ON allows chebfun to attampt to deal with functions which
%   diverge to infinity on the domain.
%
%   MORE HERE 
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2008 by The Chebfun Team. 
%  Last commit: $Author: rodp $: $Rev: 445 $:
%  $Date: 2009-05-01 11:56:27 +0100 (Fri, 01 May 2009) $:

if nargin==0 
    switch chebfunpref('blowup')
        case 1 
            disp('BLOWUP is currently ON')
        case 0
            disp('BLOWUP is currently OFF')
    end
else
    if strcmpi(on_off, 'on')
        chebfunpref('blowup',true)
    elseif strcmpi(on_off, 'off') 
        chebfunpref('blowup',false)
    else
        error('CHEBFUN:split:UnknownOption',...
          'Unknown blowup option: only ON and OFF are valid options.')
    end
end
