close all

%% Plot Line shape
f = arabic_scribble('KAUST!');
figure
plot(f, 'linewidth',3), axis equal

%% Plot Circular shape
f = arabic_scribble('KAUST!');
figure
plot(f, 'linewidth',3), axis equal
plot(exp(3*f),'linewidth',3), axis equal
plot(exp(3i*f),'linewidth',3), axis equal

%% Plot in a special shape
f = arabic_scribble('KAUST!');
figure
plot(exp(-9i+.2*(2+12.5i)*f),'linewidth',3), axis equal

%% Diffusing
f = arabic_scribble('KAUST!');
d = domain([f.ends([1,end])]);
L = expm(.00005*diff(d,2) & 'neumann');
f = L*f;
clc
figure
plot(f,'linewidth',2), axis([1.2*[-1,1] [-0.05 .45]]), drawnow    
for k = 1:300
    plot(f,'linewidth',2), axis([1.2*[-1,1] [-0.05 .45]]), drawnow    
    f = L*f;
end
chebfunpref('factory');

