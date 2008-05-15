function varargout = subsasgn(f,index,varargin)
%     F(I) = G assigns the chebfun G into the interval of the chebfun F specifed 
%     by the domain I. A(I,C) = F assigns the chebfun F to the column C of a 
%     quasi-matrix A.  A colon used as a subscript in the first argument, as in 
%     A(:,C) = F, indicates the entire chebfun column.
%  
%     F(PTS) = VALS assigns the values of vector VALS at locations
%     specified in vector PTS in the chebfun F. length(PTS) should be equal
%     to length(VALS)). Subsasgn introduces new break-points in F at points
%     in PTS that were not before in F.ENDS. Similarly, A(PTS,C) = VALS
%     assigns values for specific points PTS of the column C of a
%     quasimatrix A.
%  
%     F{A,B} = G is a wrapper for the command DEFINE(F,[A,B],G).
%  
%     F.FIELD = B is a wrapper for the command SET(F,FIELD,B), where FIELD
%     is any of the chebfun fields.
%
% Chebfun Version 2.0
idx = index(1).subs;
switch index(1).type
    case '.'
        varargout = {set(f,idx,varargin{:})};
    case '()'
        % --- transpose row chebfuns/quasimatrices -------
        trans = 0;
        if get(f,'trans')
            trans = 1;
            f = f';
            idx = fliplr(idx);
        end
        n = size(f,2);  
        s = idx{1};
        % ---- read input arguments -----------------------------
        if length(idx) == 1  
            % f(s), where s can be vector, domain or ':'
            % syntaxis not allowed when f is a quasimatrix
            if n ~= 1
                error('chebfun:subsasgn:dimensions',...
                    'Index missing for quasi-matrix assignment.')
            end
            col = 1;          
        elseif length(idx) == 2
            % f(s,col), where s can be vector, domain or ':'
            col = idx{2}; 
            if (isnumeric(col) & length(col)>1) | ~isequal(s,':')                    
                error('chebfun:subsasgn:multiplecols',...
                    'Assignment of more than one column/row not available yet.')
            end
            if col > n
                f(:,n+1:col) = repmat(chebfun(0,domain(f)),1,col-n);
            end
        else
            error('chebfun:subsasgn:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        fcol = f(:,col);        
        % ---- assign values/chebfuns at given points/domains ---        
        if isnumeric(s)
            if ~isa(varargin{:},'numeric')
                error('chebfun:subsref:conversion',...
                        ['Conversion to numeric from ',class(varargin{:}),...
                        'is not possible.'])
            end
            if length(s) == length(varargin{:})
                if min(s) < f.ends(1) || max(s) > f.ends(end)
                    error('chebfun:subsref:outbounds',...
                        'Cannot introduce endpoints outside domain.')
                end
                [a,b] = domain(fcol);
                stemp = s;
                s(find(s==fcol.ends(end))) = [];
                for i = s
                    fcol = [restrict(fcol,[a,i]); restrict(fcol,[i,b])];                    
                end 
                [mem,loc] = ismember(stemp,fcol.ends);
                v = varargin{:};
                fcol.imps(1,loc(find(loc))) = v(find(mem)); 
            else
                error('chebfun:subsref:dimensions',...
                    ['In an assignment  A(I) = B, the number of '...
                    'elements  in B and I must be the same.'])
            end
        elseif isa(s,'domain')
            fcol = define(fcol,s,varargin{:});
        elseif isequal(s,':')
            if isempty(fcol)
                fcol = define(fcol,domain(varargin{:}),varargin{:});
            else
                fcol = define(fcol,domain(fcol),varargin{:});
            end
        else
            error('chebfun:subsref:nonnumeric',...
              'Cannot evaluate chebfun for non-numeric type.')
        end
        % --- assign modified column to original chebfun/quasimatrix ---
        f(:,col) = fcol;
        if trans, f = f'; end
        varargout = { f };          
    case '{}'
        if length(idx) == 1
            if isequal(idx{1},':')
                s = domain(f); 
            else
                error('chebfun:subsref:baddomain',...
                    'Invalid domain syntax.')
            end
        elseif length(idx) == 2
            s = domain(cat(2,idx{:}));
        else
            error('chebfun:subsasgn:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        varargout = { define(f,s,varargin{:}) };
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end