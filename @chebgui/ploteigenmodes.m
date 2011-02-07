function ploteigenmodes(guifile,handles,h1,h2)
% Plot the eigenmodes in the GUI

if nargin < 3, h1 = handles.fig_sol; end
if nargin < 4, h2 = handles.fig_norm; end

if ~handles.hasSolution
    return
end

D = handles.latestSolution;
V = handles.latestSolutionT;

C = get(0,'DefaultAxesColorOrder');
C = repmat(C,ceil(size(D)/size(C,1)),1);

if ~isempty(h1)
    axes(h1)
    for k = 1:size(D)
        plot(real(D(k)),imag(D(k)),'.','markersize',25,'color',C(k,:)); hold on
    end
    hold off
    if guifile.options.grid, grid on, end
    title('Eigenvalues'); xlabel('real'); ylabel('imag');
end

if isempty(h2), return, end

isc = iscell(V);
nV = numel(V);

if get(handles.button_realplot,'Value')
    if ~isc
        V = real(V);
    else
        for k = 1:nV
            V{k} = real(V{k});
        end
    end
    s = 'Real part of eigenmodes';
elseif get(handles.button_imagplot,'Value')
    if ~isc
        V = imag(V);
    else
        for k = 1:nV
            V{k} = imag(V{k});
        end
    end
    s = 'Imaginary part of eigenmodes';
else
    V = V.*conj(V);
    s = 'Absolute value of eigenmodes';
end

axes(h2)
if ~isc
    plot(V,'linewidth',2);
    if guifile.options.grid, grid on, end
    ylabel(handles.varnames);
else
    LS = repmat({'-','--',':','-.'},1,ceil(numel(V)/4));
    ylab = [];
    for k = 1:nV
        plot(real(V{k}),'linewidth',2,'linestyle',LS{k}); hold on
        ylab = [ylab handles.varnames{k} ', ' ];
    end
    hold off
    ylabel(ylab(1:end-2));
end
xlabel('x')
title(s);


