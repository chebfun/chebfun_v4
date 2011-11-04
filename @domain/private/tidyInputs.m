function [n map breaks numints] = tidyInputs(n,d,filename)
% TIDYINPUTS - tidy the inputs to varmat constructors
%      [n map breaks numints] = tidyInputs(n,d,filename)
% Ensures that breakpoints are inherited/disregarded correctly and that the
% lenght of n is right for the given domain/breaks. 

breaks = []; map = [];
if iscell(n)
    if numel(n) > 1, map = n{2}; end
    if numel(n) > 2, breaks = n{3}; end
    if isa(breaks,'domain'), breaks = breaks.ends; end
    n = n{1};
end

% Force a default map for unbounded domains.
if any(isinf(d)) && isempty(map)
    if isempty(breaks), map = maps(d); end
end   

% Inherit the breakpoints from the domain.
breaks = union(breaks, d.ends);
% Throw away breaks (and corresponding n) outside the domain.
maskr = breaks > d.ends(end);     maskl = breaks < d.ends(1);       
if numel(n) > 1,  n(maskr) = [];  n(maskl) = []; end
breaks(maskl|maskr) = [];
numints = numel(breaks)-1;

% Tidy up breaks and n.
if numints == 1
    % Breaks are the same as the domain ends. Set to [] to simplify.
    breaks = [];
elseif numel(breaks) > 2
    % Repmat n if necessary - or check for mismatch
    if numel(n) == 1, n = repmat(n,1,numints); end
    if numel(n) ~= numints
        if nargin < 3, filename = 'unknown'; end
        error(['DOMAIN:',filename,':numints'],...
            'Vector N does not match domain D.');
    end
end
