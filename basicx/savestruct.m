function savestruct(str___,ofn___)
% Save the fields of a structure.
%   SAVESTRUCT(str,ofn) implements Matlab V7's "SAVE -STRUCT" for Matlab V6.
%   That is, the fields in STR gets saved as individual variables in the
%   file OFN.

flds___ = fieldnames(str___); N___ = length(flds___);
for n___ = 1:N___
  eval(sprintf('%s = str___.%s;',flds___{n___},flds___{n___}));
end

save(ofn___,flds___{:});

