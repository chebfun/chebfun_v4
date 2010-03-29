function t = tree(varargin)

switch nargin
    case 1
        t.leafs.center = varargin{1};
    case 2
        t.leafs.center = varargin{1};
        t.leafs.right  = varargin{2};
    case 3
        t.leafs.left   = varargin{1};
        t.leafs.center = varargin{2};
        t.leafs.right  = varargin{3};
end
% switch nargin
%     case 1
%         t.center = varargin{1};
%     case 2
%         t.center = varargin{1};
%         t.right  = varargin{2};
%     case 3
%         t.left   = varargin{1};
%         t.center = varargin{2};
%         t.right  = varargin{3};
% end
        

end