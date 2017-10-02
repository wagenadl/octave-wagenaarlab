function x = stringhash(str)
% x = STRINGHASH(str) returns a hash value based on a string

multiplier = 2 + 32 + 128;
modulo = 1324789231;
x=0;
for k=1:length(str)
  x = mod(x*multiplier,modulo) + str(k);
end
