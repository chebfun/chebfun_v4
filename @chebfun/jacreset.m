function varargout = jacreset(varargin)
% JACRESET Resets the Jacobian field of a chebfun such that the .jac field
% of the output function is the identity operator.
%
% U = jacreset(v1,v2,...,vn) returns a quasimatrix which columns are the
% chebfuns v1, v2, ..., vn. The Jacobian for each column function is a 1xn
% block matrix such that the Jacobian for column i is zero outside block i.
%
% [u1, u2, ..., un] = jacreset(v1,v2,...,vn) returns n column chebfuns v1, v2,
% ..., vn. The Jacobian for each function is a 1xn block matrix such that
% the Jacobian for function i is zero outside block i.
%
% U = jacreset(V). Same as U = jacreset(v1,v2,...,vn) but for a quasimatrix V.
%
% [u1, u2, ..., un] = jacreset(V). Same as jacreset[u1, u2, ..., un] =
% jacreset(v1,v2,...,vn) but for a quasimatrix V.
%
% See also DIFF

% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author: hale $: $Rev: 987 $:
%  $Date: 2009-12-15 10:13:36 +0000 (Tue, 15 Dec 2009) $:

% SKIP?
% Begin by making sure all chebfuns passed in are column vectors. If not we
% transpose them in order to ensure we will only work with column vectors.

if nargin == 1 && nargout == 1
    % Either a Quasimatrix -> Quasimatrix or just a single chebfun
    chebfuns = varargin{1};
    quasiMat = [];
    numOfChebfuns = numel(chebfuns);
    jacVectors = eye(numOfChebfuns);
    
    for i = 1:numOfChebfuns
        jacVector = jacVectors(i,:);
        quasiMat = [quasiMat jacResetFun(chebfuns(:,i),jacVector)];
    end
    varargout = {quasiMat};
elseif nargin == 1 && nargout == numel(varargin{1})
    % Quasimatrix -> Multiple chebfuns
    chebfuns = varargin{1};
    numOfChebfuns = numel(chebfuns);
    jacVectors = eye(numOfChebfuns);
    
    for i = 1:numOfChebfuns
        jacVector = jacVectors(i,:);
        varargout{i} = jacResetFun(chebfuns(:,i),jacVector);
    end
elseif nargout == 1 && nargin > 1
    % Multiple chebfuns -> Quasimatrix
    jacVectors = eye(nargin);
    quasiMat = [];
    for i = 1:nargin
        jacVector = jacVectors(i,:);
        quasiMat = [quasiMat jacResetFun(varargin{i},jacVector)];
    end
    varargout = {quasiMat};
elseif nargout == nargin
    % Multiple chebfuns -> Multiple chebfuns
    % We use row i of the jacVectors matrix to set up the Jacobian in
    % iteration i.
    jacVectors = eye(nargin);
    for i=1:nargin
        jacVector = jacVectors(i,:);
        varargout{i} = jacResetFun(varargin{i},jacVector);
    end
else
    error('CHEBFUN:jacreset:numout','Number of outputs does not match number of inputs');
end

end

function out =  jacResetFun(F,jac)
d = domain(F(1));
I = eye(d);
if isnumeric(jac)  % scalars given to represent Jacobians
    % One row of numbers per quasimatrix element?
    if numel(F) > size(jac,1)
        jac = repmat(jac(1,:),[numel(F),1]);
    end
    % In row i, construct kron(jac(i,:),I), and store.
    for i = 1:numel(F)
        J = [];
        for j = 1:size(jac,2)
            J = [ J, jac(i,j)*I ];
        end
        F(i).jacobian = anon('@(u) J',{'J'},{J});
    end
else   % linops given for the Jacobians
    % Make copies if necessary (and wrap in cell to do it).
    if ~iscell(jac)
        jac = repmat({jac},[numel(F),1]);
    end
    for i = 1:numel(F)
        F(i).jacobian = anon('@(u) jac',{'jac'},{jac(i)});
    end
end
out = F;

end