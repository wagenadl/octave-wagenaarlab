function img = insideborder(img)
% img = INSIDEBORDER(img) returns the inside edge of the area(s) in IMG 
% that have non-zero pixel values.
img = 0*img + (~~img);
dimg = ~convn(~img,[0 1 0; 1 1 1; 0 1 0],'same');
img = 0*img + (~~img & ~dimg);
