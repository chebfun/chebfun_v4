function s = char(d)

if isempty(d)
  s = '   empty domain';
else
  s = sprintf('   interval [%g,%g]',d.ends([1 end]));
  if length(d.ends) > 2
    breaks = sprintf(' %g,',d.ends(2:end-1));
    breaks(end)=[];
    cws = get(0,'commandwindowsize');
    if length(breaks) > cws(1)-length(s)-24
      breaks = sprintf(' %g, ..., %g',d.ends(2),d.ends(end-1));
    end
    s = [ s ' with breakpoints' breaks ];
  end
end

end