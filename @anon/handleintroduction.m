%% Storing the AD information
%
%% Introduction and first approach
%
% Common to all approaches we have taken to store the AD information has
% been that we introduced a new field in the chebfun object (called
% jacobian - when the merging starts we will change the name of the field
% to jac). We write into the jacobian field every time an operation is
% performed on the chebfun (such as +, -, sin etc.) and can later use that
% information to create the Jacobian operator.
%
% The first approach we took to store the AD information was to simply
% create an anonymous function and assign it to the jacobian field. For
% example, in the function plus, we would have
h.jacobian = @(u) jacobian(f1,u)+jacobian(f2,u);
%
% where h is the chebfun returned and f1 and f2 the arguments passed to the
% function (i.e., h = f1 + f2). This was found to slow down some of the
% chebtests significantly, especially those that relied on iterative
% processes (such as the falknershan test). The reason for this was found
% to be the way Matlab creates anonymous functions. When such functions
% created, Matlab wants to store in the object all information necessary to
% be able to call it later, even though the parameters it depends upon go
% out of scope, get cleared or changed later. Hence, in an iterative
% process, when the jacobian function is created, Matlab has to look back
% up all the evaluation trace which is time consuming and unefficient. This
% much amount of information is also unecessary for our application. A
% different approach thus had to be taken.
%
%% Nested functions
%
% Jamm
1+2
% 
% Recall how 
% The first approach taken to work with the AD information was to assign 