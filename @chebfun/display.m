function display(F)
% DISPLAY   Display a chebfun.
% DISPLAY(F) outputs important information about the chebfun F to the
% command window, including its domain of definition, its length (number of
% sample values used to represent it), and a summary of its values. Each
% row or column is displayed if F is a quasimatrix.
%
% It is called automatically when the semicolon is not used at the
% end of a statement that results in a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

disp([inputname(1) ' = '])

if numel(F)>1
    for k=1:numel(F)
   
        f=F(k);
        
        if f.trans==0
            columnstr=['   chebfun column ', int2str(k)];
        else
            columnstr=['   chebfun row ', int2str(k)];
        end
    
        displaychebfun(F(k),columnstr)
        
    end
        
else
    
    if F.trans==0
        columnstr='   chebfun column';
    else
        columnstr='   chebfun row';
    end
    
    displaychebfun(F,columnstr)
    
end


% -----------------------------------------------------

function displaychebfun(f, columnstr)
    
    % compact version
    if isempty(f)
         disp('empty chebfun'), disp(' ')
        return
    end

    ends = f.ends;    
    funs = f.funs;
    if f.nfuns > 1
        disp([columnstr ' (' int2str(f.nfuns) ' smooth pieces)'])
    else
        disp([columnstr ' (1 smooth piece)'])
    end    
    len = zeros(f.nfuns,1);

    % Non-trivial map used?
    % Non-trivial exponents used?
    mapped = false;
    exps = false;
    for k = 1:f.nfuns
        if ~(strcmp(f.funs(k).map.name,'linear') || strcmp(f.funs(k).map.name,'unbounded'))
            mapped = true;
        end
        if any(f.funs(k).exps)
            exps = true;
        end
    end
    
    % If any non-trivial exponents
    extras =' ';
    if exps
        extras = '   exponents';
    end
    % If non-linear map, display "mapped Chebyshev instead"
    if mapped        
        extras= [extras '     mapping'];
    end
     
    fprintf('       interval          length    endpoint values %s \n',extras)
    for j = 1:f.nfuns
        len(j)= funs(j).n;
        
        % values at endpoints
        endvals(1) = get(funs(j),'lval');
        endvals(2) = get(funs(j),'rval');
        
        if exps
            funs(j).exps(~logical(funs(j).exps)) = 0; % This prevents the display of -0 (a bug in matlab)
            exinfo = ['    ' num2str(funs(j).exps, '%5.2g') '  '];            
        else
            exinfo = ' ';
        end
        if ~any(isnan(endvals))
            endvals(~logical(abs(endvals))) = 0;
        end
        
        if mapped
            pars = funs(j).map.par(3:end);
            if numel(pars) > 2 && ~strcmpi(funs(j).map.name,'sing'), pars = []; end
            exinfo = [exinfo '    ' funs(j).map.name ' ' num2str(pars,'%5.2g')];    
        end
        
        if ~isreal(funs(j).vals)
            fprintf('(%9.2g,%9.2g)   %7i      Complex values %s \n', ends(j), ends(j+1), len(j), exinfo);
        else
            fprintf('(%9.2g,%9.2g)   %6i  %9.2g %9.2g %s \n', ends(j), ends(j+1), len(j), endvals, exinfo);
        end        
    end
    
    if f.nfuns > 1
        fprintf('Total length = %i   vertical scale = %3.2g \n', sum(len), f.scl)
    else
        fprintf('vertical scale = %3.2g \n', f.scl)
    end
    disp(' ')