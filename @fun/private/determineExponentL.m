
function exponent = determineExponentL(OP)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% includes DECIMAL search for fractional powers %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path=0;             % initialise to path 0

[diverge,path] = blowupL(OP,path);

if  path==0
    exponent=0;
    
else
    exponent=1;
    
    [diverge,path] = blowupL(softenL(OP,exponent),path);
    
    while   diverge == 1
        
        exponent = exponent + 1;
        
        if exponent > 20
            exponent = 0; return
            error('singularity is too strong for markfun to approximate');
            
        end
        
        [diverge,path] = blowupL(softenL(OP,exponent),path);
        
    end
    
    a=exponent-1; b=exponent;            % Set interval [a,b]
    
    switch path
        case 1
            tol=0.00000000001;
        case 2
            tol=0.01;
    end
    
    while abs(b-a) > 1.1*tol             % 1.1* prevents extra iteration
        
        points = [a : (b-a)/10 : b]';
        
        i=1; exponent = points(i);
        
        [diverge,path] = blowupL(softenL(OP,exponent),path);
        
        while diverge==1
            
            i=i+1;
            exponent=points(i);
            
            [diverge,path] = blowupL(softenL(OP,exponent),path);
            
        end
        
        a=points(i-1); b=points(i);
        
    end
    
    switch path
        case 1
            exponent = b;
        case 2
            exponent = b+1;
    end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Function performs two consecutive tests on the input operator to %%%%%
%%%% determine whether it blows up (1) or not (0) %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [diverge,path] = blowupL(OP,path)

switch path
    
    case 0                  % First time function is executed sets the path
        
        if blowupA(OP)==0 && blowupB(OP)==0
            diverge = 0;
            path = 0;
            
        elseif  blowupA(OP)==0 && blowupB(OP)==1
            diverge=1;
            path = 2;
            
        else
            diverge=1;
            path = 1;
            
        end
        
    case 1
        
        diverge = blowupA(OP);
        
    case 2
        
        diverge = blowupB(OP);
        
end

end


function [divergeA] = blowupA(OP)

m=[0:10]';
%epss=-1+m*eps;
epss=-1+100*m*eps;

vals=abs(OP(epss));

FDs=diff(vals);

FDs=FDs(2:end);

monotonic=0;
for i=1:length(FDs)-1
    if FDs(i)<FDs(i+1)
        monotonic=monotonic+1;
    end
end

if monotonic>=length(FDs)-1
    divergeA=1;
else
    divergeA=0;
end

end


function [divergeB] = blowupB(OP)

n=15;
result=zeros(1,n);ratio=zeros(1,n-1);test=zeros(1,n-2);

for i=1:n
    result(i)=OP(-1+10^(-i));
end

for i=1:n-1
    ratio(i)=result(i+1)/result(i);
    if i>1                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if abs(ratio(i))<1.01     %%%%% <- This line could be crucial
            test(i-1)=0;                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            test(i-1)=1;
        end
    end
    
end

total=sum(test);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if total>10                       %%%%% <-----  As could this line
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    divergeB=1;
    
else
    divergeB=0;
end

end


function softenedFun = softenL(OP,exponent)

% This function takes Op and exponent as inputs and returns the operator
% multiplied by (1-x)^exponent.

softenedFun = @(x) (1+x).^exponent.*OP(x);

end