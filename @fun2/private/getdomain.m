function rect = getdomain(f)
% returns the domain of a fun2. 

u=[-1 1]; rect = f.map.for(u,u); 
end 