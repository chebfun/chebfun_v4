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
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

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

    % Non-linear map used?
    mapped = false;
    for k = 1:f.nfuns
        if ~strcmp(f.funs(k).map.name,'linear')
            mapped = true;
            break
        end
    end
    
    % If non-linear map, display "mapped Chebyshev instead"
    if mapped        
        disp('          interval          length   values at mapped Chebyshev points')
    else
        disp('          interval          length   values at Chebyshev points')
    end
     
    for j = 1:f.nfuns
        len(j)= funs(j).n;
        if ~isreal(funs(j).vals)
            fprintf('(%9.2g,%9.2g)   %7i       Complex values \n', ends(j), ends(j+1), len(j));
        else
            switch len(j)
                case 1
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g \n', ends(j), ends(j+1), len(j), funs(j).vals)
                case 2
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g\n', ends(j), ends(j+1), len(j), funs(j).vals)
                case 3
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g %10.2g \n', ends(j), ends(j+1), len(j), funs(j).vals)
                case 4
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g %10.2g %10.2g \n', ends(j), ends(j+1), len(j), funs(j).vals)
                otherwise
                    v = funs(j).vals;
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g %10.2g ... %10.2g\n', ends(j), ends(j+1), len(j), v(1:3), v(end))
            end
        end        
    end
    if f.nfuns > 1
        fprintf('Total length = %i \n', sum(len))
    end
    disp(' ')