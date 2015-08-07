 function S = scale_ls(counts)
 % Use the least squares (complete matrix) solution
 % (Thurstone 1927, Mosteller 1951) to
 % scale a paired comparison experiment using
 % Thurstone's case V model (assuming sigmaˆ2 = 0.5 for each
 % quality's distribution)
 %
 % counts is a n?by?n matrix where
 % counts(i,j) = # people who prefer option i over option j
 % S is a length n vector of scale values
 %
 % 2011?06?05 Kristi Tsukida <kristi.tsukida@gmail.com>

 [m,mm] = size(counts);
 assert(m == mm, 'counts must be a square matrix');

 % Empirical probabilities
 N = counts + counts';
 P = counts ./ (N + (N==0)); % Avoid divide by zero
 P(eye(m)>0) = 0.5; % Set diagonals to have probability 0.5

 Z = norminv(P);
 S = -mean(Z,1)';
 
 end