function s = singmap(on_off)
%SINGMAP   CHEBFUN singular mapping option
%   SINGMAP ON allows the chebfun constructor to use singluar maps to 
%   deal with singularities at endpoints.
%   SINGMAP OFF disables this kind of mappings.
%   SINGMAP, by itself, displays the current splitting state.
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2008 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

persistent singstate

if isempty(singstate)
    singstate = false;
end

if nargin==0
    if nargout == 1
        s = singstate;
    else
        switch singstate
            case 1
                disp('SINGMAP is currently ON')
            case 0
                disp('SINGMAP is currently OFF')
        end
    end
else
    if strcmpi(on_off, 'on')
        singstate = true;
    elseif strcmpi(on_off, 'off')
        singstate = false;
    else
        error('CHEBFUN:singstate:UnknownOption',...
            'Unknown SINGMAP option: only ON and OFF are valid options.')
    end
end
