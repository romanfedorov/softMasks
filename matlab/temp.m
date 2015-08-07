 c = [
     0 1 5
     28 0 11
     10 10 0
     ];
 c = m;
 
cfix = fix_counts(c);

thresh = 2;

y = scale_ls(cfix);
y = (y - min(y))./(max(y)-min(y));
