function varargout = why(f,r)  
%WHY  Provides a succinct answer to almost any chebfun related 
%     question in the many languages of the friends of chebfun.
%
%     For fun, try also
%       plot(why(chebfun)), axis equal

N = 8;  % Number of chebfun languages
if nargin == 1
    r = ceil(N*rand);
end
    
switch r
    case 1,         s = 'Because Nick Trefethen said so!';
        % English (or American-English!):
        % Nick Trefethen, Toby Driscoll, Nick Hale,  
        % Sheehan Olver, Mark Richardson, Zachary Battles (?)
        
    case 2,         s = 'Porque Nick Trefethen lo dice!';
        % Spanish:
        % Ricardo Pachon
        
    case 3,         s = 'Porque o Nick Trefethen disse!';
        % Portuguese:
        % Rodrigo Platte
                
    case 4,         
        if getfield(ver('matlab'),'Version') >= 7.9
                    s = 'Því Nick Trefethen mælti svo!';
        else
                    s = 'Thvi Nick Trefethen maelti svo!';
        end
        % Icelandic:
        % Asgeir Birkisson
        
    case 5,
        if getfield(ver('matlab'),'Version') >= 7.9
                    s = 'Omdat Nick Trefethen so sê!';
        else
                    s = 'Omdat Nick Trefethen so se!';
        end
        % Afrikaans:
        % Andre Weideman
        
    case 6,         s = 'Omdat Nick Trefethen het zegt!';
        % Dutch:
        % Joris Van Deun
        
    case 7,         s = 'Wills dr Nick Trefethen gseit hett!';
        % Swiss German:
        % Pedro Gonnet
    
    case 8,         s = 'Parce que Nick Trefethen le dit!';
        % French:
        % Cecile Piret
    
    otherwise,      s = 'Good question!';
end

if nargout < 1
    disp(s)
else
    varargout{1} = scribble(s);
end
    

