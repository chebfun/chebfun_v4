function f = ctor_adapt(f,ops,ends,pref)
%CTOR_ADAPT  Adaptive chebfun constructor
% CTOR_ADAPT handles adaptive construction of chebfuns.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author: nich $: $Rev: 458 $:
% $Date: 2009-05-10 20:51:03 +0100 (Sun, 10 May 2009) $:

if length(ends) ~= length(ops)+1
    error(['Unrecognized input sequence: Number of intervals '...
        'do not agree with number of funs'])
end
if any(diff(ends)<0), 
    error(['Vector of endpoints should have increasing values'])
end
funs = [];
hs = norm(ends([1,end]),inf);
if isinf(hs)
   inends = ~isinf(ends);
   if any(inends)
       hs = max(max(abs(ends(inends))+1));
   else
       hs = 2;
   end
end
scl.v=0; scl.h= hs;
newends = ends(1);
newops = {};

if isa(ops,'chebfun')
    if numel(ops) > 1
        error('chebfun:ctor_adapt','Only one chebfun is allowed for this call');
    end
    if ops.ends(1) <= ends(1) && ops.ends(end) >= ends(end)
        f = restrict(f,[ends(1) ends(end)]);
    else
        error('chebfun:ctor_adapt:domain','chebfun is not defined in the domain')
    end
    return
end

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

for i = 1:length(ops)
    op = ops{i};
    if isfield(pref,'exps'), pref.exps = {exps{2*i+(-1:0)}}; end
    switch class(op)
        case 'double'
            if ~isfield(pref,'map')
                fs = fun(op,ends(i:i+1));
            else
                fs = fun(op,maps(pref.map,ends(i:i+1)));
            end
            es = ends(i:i+1);
            scl.v = max(scl.v, fs.scl.v);
        case 'fun'
            if numel(op) > 1
            error(['A vector of funs cannot be used to construct '...
                ' a chebfun.'])
            end
            if norm(op.map.par(1:2)-ends(i:i+1)) > scl.h*1e-15
                error('chebfun:ctor_1:domain','Incosistent domains')
            else
                fs = op;
                es = ends(i:i+1);
                scl.v = max(scl.v, fs.scl.v);
            end
        case 'char'
            if ~isempty(str2num(op))
                error(['A chebfun cannot be constructed from a string with '...
                    ' numerical values.'])
            end
%             op = inline(op);
            depvar = symvar(op); 
            if numel(depvar) ~= 1, 
                error('Incorrect number of dependent variables in string input'); 
            end
            op = eval(['@(' depvar{:} ')' op]);
            op = vectorcheck(op,ends(i:i+1),pref.vecwarn);         
            [fs,es,scl] = auto(op,ends(i:i+1),scl,pref);
        case 'function_handle'
            op = vectorcheck(op,ends(i:i+1),pref.vecwarn);        
            [fs,es,scl] = auto(op,ends(i:i+1),scl,pref);
        case 'chebfun'
            if op.ends(1) > ends(1) || op.ends(end) < ends(end)
                 warning('chebfun:c_tor2:domain','chebfun is not defined in the domain')
            end
            if isfield(pref,'exps'), pref.exps = {exps{2*i+(-1:0)}}; end
            [fs,es,scl] = auto(@(x) feval(op,x),ends(i:i+1),scl,pref);
        case 'cell'
            error(['Unrecognized input sequence: Attempted to use '...
                'more than one cell array to define the chebfun.'])
        otherwise
            error(['The input argument of class ' class(op) ...
                'cannot be used to construct a chebfun object.'])
    end
    % Concatenate funs, ends and handles (or ops)   
    funs = [funs fs];
    newends = [newends es(2:end)];
    for k = 1:numel(fs), newops{end+1} = op; end;
end


imps = jumpvals(funs,newends,newops,pref,scl.v); % Update values at jumps, first row of imps.
scl.v = max(scl.v,norm(imps(~isinf(imps)),inf));
f.nfuns = length(newends)-1; 
% update scale and check if simplification is needed.
for k = 1:f.nfuns
    funscl = funs(k).scl.v;
    funs(k).scl = scl;      % update scale field
    if  funscl < scl.v/10   % if scales were significantly different, simplify!
        funs(k) = simplify(funs(k),pref.eps);
    end
end
% Assign fields to chebfuns.
f.funs = funs; f.ends = newends; f.imps = imps; f.trans = false; f.scl = scl.v;
f.ID = newIDnum();
 if length(f.ends)>2 
     f = merge(f,find(~ismember(newends,ends)),pref); % Avoid merging at specified breakpoints
 end
