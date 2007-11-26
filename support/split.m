function split(on_off)
%SPLIT   CHEBFUN split option
%  SPLIT ON allows the chebfun constructor to split the interval. This
%  option is recommended when working with piecewise smooth functions. 
%  SPLIT OFF disables splitting when a chebfun object is constructed using
%  the CHEBFUN command.
%  SPLIT, by itself, displays the current split state.
%

if nargin==0 
    switch getpref('chebfun_defaults','splitting')
        case 1 
            disp('SPLIT is currently ON')
        case 0
            disp('SPLIT is currently OFF')
    end
else
    if strcmp(on_off, 'on') || strcmp(on_off, 'ON')
        setpref('chebfun_defaults','splitting',1)
    elseif strcmp(on_off, 'off') || strcmp(on_off, 'OFF')
        setpref('chebfun_defaults','splitting',0)
    else
        error('CHEBFUN:split:UnknownOption', 'Unknown split option: only ON and OFF are valid options.')
    end
end