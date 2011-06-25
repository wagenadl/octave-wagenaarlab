function img = outsideborder(img)
% img = OUTSIDEBORDER(img) returns the outside edge of the area(s) in IMG 
% that have non-zero pixel values.

img = 0*img +(img>0);
dimg = convn(img,[0 1 0; 1 1 1; 0 1 0],'same');
img = 0*img + (~~dimg & ~img);
