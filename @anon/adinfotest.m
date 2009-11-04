[d,x] = domain(0,2);

ADhandle.function = '@(y)y*sin(w{1}) + w{2}';
ADhandle.type = 'ADhandle';
ADhandle.workspace = {x cos(50*x)};

ADhandle


