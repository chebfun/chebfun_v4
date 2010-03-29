function type = findtype(str,prevtype)

if regexp(str, '[0-9]') % Breyta i float  [+-]?(([0-9]+(.[0-9]*)?|.[0-9]+)([eE][+-]?[0-9]+)?)
    type = 'num';
% If we want to treat unary operators especially
elseif (strcmp(prevtype,'operator') || strcmp(prevtype,'unary')) && ~isempty(regexp(str, '[+-]'))
    type = 'unary';
elseif regexp(str,'[A-Za-z_]')
    type = 'char';
elseif str == '.' % We need to be able to distinguish between doubles and operators
    type = 'point';
elseif regexp(str,'.?[\+\-\*\/\.\^\(\)]')
    type = 'operator';
elseif regexp(str,'''')
    type = 'deriv';
else
    type = 'error';
end

end