function varargout = subsref(f,index)
% SUBSREF   subscripted reference
% F(X) returns the values of the chebfun F evaluated on the array X. The 
% function at the right of a breakpoint x is used for the evaluation of F
% on x.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0

switch index(1).type
    case '.'
        if isempty(f)
            varargout = {};
        else
            switch index(1).subs
                case 'funs'
                    varargout = {f.funs};
                case 'ends'
                    varargout = {f.ends};
                case 'vals'
                    vals = [];
                    for i = 1:f.nfuns
                      vals = [vals;f.funs{i}.val];
                    end
                    varargout = {vals};
                case 'grid'
                    grid = [];
                    for i = 1:f.nfuns
                      grid = [grid; flipud(cheb(f.funs{i}.n, ...
                          f.ends(i),f.ends(i+1)))];
                    end
                    varargout = {grid};
                case 'nfuns'
                    varargout = {f.nfuns};
                case 'npts'
                    npts = 0;
                    for i = 1:f.nfuns
                      npts = npts + f.funs{i}.n;
                    end
                    varargout = {npts};
                case 'ptsfun'
                    ptsfun = [];
                    for i = 1:f.nfuns
                      ptsfun = [ptsfun; f.funs{i}.n];
                    end
                    varargout = {ptsfun};
            end
        end
        
        if length(index) > 1
            if length(f(:)) == 1
                varargout = {subsref([varargout{:}], index(2:end))};
            else
                [err_id, err_msg] = array_reference_error(index(2).type);
                error(err_id, err_msg);
            end
        end
           
    case '()'
        nfuns = length(f.funs);
        ends = f.ends;
        s = index.subs{1};
        [X,I] = rescale(s,ends);
        F = zeros(size(s));
        if nfuns == 0
            % This is an old safeguard. It might be removed
            ffuns = f.funs;
            F = ffuns(X);
            warning('Safeguard in SUBSREF has been used. Please contact support.')
        else
            for i = 1:nfuns
                ffun = f.funs{i};
                pos = find(I==i);
                F(pos) = ffun(X(pos));
            end
        end
        if any(f.imps(1,:))
            s = s(:).';
            [val,loc,pos] = intersect(s,ends);
            F(loc(any(f.imps(:,pos)>0,1))) = inf;
            F(loc(any(f.imps(:,pos)<0,1))) = -inf;
        end
        varargout = {F};
    case '{}'
        error('??? chebfun object, not a cell array');
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end

if length(varargout) > 1 & nargout <= 1
    if iscellstr(varargout) || any([cellfun('ismpety',varargout)])
        varargout = {varargout};
    else
        try
            varargout = {[varargout{:}]};
        catch
            varargout = {varargout};
        end
    end
end