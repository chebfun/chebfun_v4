function export2mfile(pathname,filename,handles)

fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');



a = get(handles.dom_left,'String');
b = get(handles.dom_right,'String');
DE = get(handles.input_DE,'String');

fprintf(fid,'[d,x,N] = domain(%s,%s);\n',a,b);

fprintf(fid,'options = cheboppref; ');

fclose(fid);

1+2;
end