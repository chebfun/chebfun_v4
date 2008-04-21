function [out,i] = min(f)
% MIN	Global minimum on [-1,1]
% MIN(F) is the global minimum of the fun F on [-1,1].
% [Y,X] = MIN(F) returns the value X such that Y = F(X), Y the global minimum.

[out,i] = max(-f);
out=-out;