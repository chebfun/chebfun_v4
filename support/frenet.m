function [t,n,b]=frenet(alpha)

D = {diff(alpha{1}); diff(alpha{2}); diff(alpha{3})};
DD = {diff(D{1}); diff(D{2}); diff(D{3})};

DxDD = riccross(D,DD);

Dnorm = sqrt(D{1}.^2 + D{2}.^2 + D{3}.^2);
DxDDnorm = sqrt(DxDD{1}.^2 + DxDD{2}.^2 + DxDD{3}.^2);

t = {D{1}./Dnorm; D{2}./Dnorm; D{3}./Dnorm};
b = {DxDD{1}./DxDDnorm; DxDD{2}./DxDDnorm; DxDD{3}./DxDDnorm};
n = riccross(b,t);






