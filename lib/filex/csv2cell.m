function cc = csv2cell(fn)
% CSV2CELL - Load CSV into cell array
%    cc = CSV2CELL(fn) loads the .CSV file FN into a cell array

fd = fopen(fn, 'r');
txt = fread(fd, [1 inf], '*char');
fclose(fd);
cc = csv2cel(txt);
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cc = csv2cel(txt)
lns = strtoks(txt, "\n");
cc = {};
for k=1:length(lns)
  cls = strtoks(lns{k}, ",");
  for m=1:length(cls)
    x = str2double(cls{m});
    if isnan(x)
      cc{k,m} = cls{m};
    else
      cc{k,m} = x;
    end
  end
end
endfunction
