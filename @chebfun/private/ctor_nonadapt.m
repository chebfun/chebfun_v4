function f = ctor_nonadapt(f,ops,ends,n,pref)
%CTOR_NONADAPT  non-adaptive chebfun constructor
% CTOR_NONADAPT handles non-adaptive construction of chebfuns.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author: nich $: $Rev: 458 $:
% $Date: 2009-05-10 20:51:03 +0100 (Sun, 10 May 2009) $:

if length(ends) ~= length(ops)+1
    error('CHEBFUN:ctor_nonadapt:input_intsfun',['Unrecognized input sequence: Number of intervals '...
        'do not agree with number of funs'])
end
if length(n) ~= length(ops)
    error('CHEBFUN:ctor_nonadapt:input_ptsfun',['Unrecognized input sequence: Number of Chebyshev '...
        'points was not specified for all the funs.'])
end
if any(diff(ends)<0), 
    error('CHEBFUN:ctor_nonadapt:input_endsvals',['Vector of endpoints should have increasing values.'])
end
if any(n-round(n))
    error('CHEBFUN:ctor_nonadapt:input_numpts',['Vector with number of Chebyshev points should consist of'...
        ' integers.'])
end

if nargin < 5, pref = chebfunpref; end
funs = [];

if isfield(pref,'exps') 
    exps = pref.exps;
    pref.blowup = true;
    if numel(exps) == 1, 
        exps = {exps{ones(1,2*numel(ends)-2)}};
    elseif numel(exps) == 2, 
        tmp = repmat({[]},1,2*numel(ends)-4);
        exps = {exps{1} tmp{:} exps{2}};
    elseif numel(exps) == numel(ends)
        if numel(ends)~=2
            warning('chebfun:ctor_adapt:exps_input1',['Length of vector exps equals length of assigned breakpoints. ', ...
            'Assuming exps are the same on either side of break.']);
            exps = {exps{ceil(1:.5:numel(exps)-.5)}};  
        end
    elseif numel(exps) ~= 2*numel(ends)-2
        error('chebfun:ctor_adapt:exps_input2','Length of vector exps must correspond to breakpoints');
    end
end

% Initial horizontal scale.
hs = norm(ends([1,end]),inf);
if hs == inf
   inends = isfinite(ends);
   if any(inends)
       hs = max(max(abs(ends(inends)+1)));
   else
       hs = 1;
   end
end
scl.v=0; scl.h= hs;

for i = 1:length(ops)
    op = ops{i};
    switch class(op)
        case 'function_handle'
            a = ends(i); b = ends(i+1);
            op = vectorcheck(op,[a b],pref.vecwarn);
            pref.n = n(i);
            if isfield(pref,'exps'), pref.exps = {exps{2*i+(-1:0)}}; end
            if ~isfield(pref,'map')
                g = fun(op, [a b], pref);
            else
                g = fun(op, maps(pref.map,ends(i:i+1)), pref);
            end
            funs = [funs g];
        case 'char'
            if ~isempty(str2num(op))
                error('CHEBFUN:ctor_nonadapt:input_strvals',['A chebfun cannot be constructed from a string with '...
                    ' numerical values.'])
            end
            a = ends(i); b = ends(i+1);
%             op = inline(op);
            depvar = symvar(op); 
            if numel(depvar) ~= 1, 
                error('Incorrect number of dependent variables in string input'); 
            end
            op = eval(['@(' depvar{:} ')' op]);
            op = vectorcheck(op,[a b],pref.vecwarn);
            pref.n = n(i);
            if isfield(pref,'exps'), pref.exps = {exps{2*i+(-1:0)}}; end
            if ~isfield(pref,'map')
                g = fun(op, [a b], pref);
            else
                g = fun(op, maps(pref.map,ends(i:i+1)), pref);
            end
            funs = [funs g];
        case 'chebfun'
            a = ends(i); b = ends(i+1);
            if op.ends(1) > a || op.ends(end) < b
                error('chebfun:ctor_nonadapt:domain','chebfun is not defined in the domain')
            end
            pref.n = n(i);
            if isfield(pref,'exps'), pref.exps = {exps{2*i+(-1:0)}}; end
            if ~isfield(pref,'map')
                g = fun(@(x) feval(op,x), [a b], n(i));
            else
                g = fun(@(x) feval(op,x), maps(pref.map,ends(i:i+1)), n(i));
            end
            funs = [funs g];
        case 'double'
            error(['Generating fun from a numerical vector. '...
                'Associated number of Chebyshev points is not used.']);
        case 'fun'
            if numel(op) > 1
                error(['A vector of funs cannot be used to construct '...
                    ' a chebfun.'])
            end
            error(['Generating fun from another. '...
                'Associated number of Chebyshev points is not used.']);
        case 'cell'
            error(['Unrecognized input sequence: Attempted to use '...
                'more than one cell array to define the chebfun.'])
        otherwise
            error(['The input argument of class ' class(op) ...
                'cannot be used to construct a chebfun object.'])
    end
    scl.v = max(scl.v, g.scl.v);
    scl.h = max(scl.h, g.scl.h);
end

% First row of imps contains function values
imps = jumpvals(funs,ends,op); 

% update scale field in funs
f.nfuns = length(ends)-1; 
for k = 1:f.nfuns
    funs(k).scl = scl;   
end

% Assign fields to chebfuns.
f.funs = funs; f.ends = ends; f.imps = imps; f.trans = false; f.scl = scl.v;
