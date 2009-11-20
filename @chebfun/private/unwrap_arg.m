function NewInputArg = unwrap_arg(varargin)

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if length(varargin) == 2
    temp = varargin{2};
    if ~isnumeric(temp)        
           % deal with the domain class
         if isa(temp,'domain'), 
             temp=double(temp);             
         else
            error(['Unrecognized input sequence: Last input arguement'...
                ' was recognized neither as the vector of endpoints nor '...
                ' as the vector of Chebyshev points.'])
         end
    end
    if length(temp) == 2
        NewInputArg = {varargin(1), temp};
    elseif length(temp) == 1
        NewInputArg = {varargin(1), chebfunpref('domain'), temp};
    %% RodP introd. this here for calls like: chebfun(@(x) sign(x),[-1 0 1])
    else%if length(varargin{1}) == 1 
            ops = cell(1,length(temp)-1);
            for k = 1:length(temp)-1, ops(k) = varargin(1); end            
            NewInputArg = {ops, temp};
    end
    %% -------------------------------------------------------------
%     else
%         error(['Unrecognized input sequence: Intervals should '...
%             'be specified when defining the chebfun with two or'...
%             ' more funs.'])
%    end
else
    temp = varargin{end};
    if ~isnumeric(temp)       
        % deal with the domain class
         if isa(temp,'domain'), 
             temp=double(temp);
         else
            error(['Unrecognized input sequence: Last input arguement'...
                ' was recognized neither as the vector of endpoints nor '...
                ' as the vector of Chebyshev points.'])
         end
    end
    if length(temp) == length(varargin)
        NewInputArg = {varargin(1:end-1), temp};
    elseif length(temp) == length(varargin)-2
        temp2 = varargin{end-1};
        if length(temp2) ~= length(varargin)-1
            if length(temp)~=1, 
                error(['Unrecognized input sequence: Intervals should '...
                'be specified when defining the chebfun with two or'...
                ' more funs.'])
            elseif length(varargin(1:end-2))==1
                ops = cell(1,length(temp)-1);
                for k = 1:length(temp2)-1, ops(k) = varargin(1); end            
                varargin = [ops varargin(end-1:end)];
            end
        end
        NewInputArg = {varargin(1:end-2), temp2, temp};
    else
        error(['Unrecognized input sequence: Intervals should '...
            'be specified when defining the chebfun with two or'...
            ' more funs.'])
    end
end