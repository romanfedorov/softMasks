 % This is a simple script which estimates scale values
 % for a paired comparison experiment.
 %
 % The maximum likelihood and MAP estimation methods require cvx
 % to be installed in the Matlab environment.
 % http://cvxr.com/cvx/
 %
 % Kristi Tsukida <kristi.tsukida@gmail.com>
 % June 5, 2011

 % clear variables;
 % close all;

 % % Generate a count data matrix
 % mu = [-1 -0.5 0 0.5 1];
 % mu = mu - sum(mu); % force mu to be zero mean
 % sigma = 1/sqrt(2); % std dev for each quality score
 % num judgments per pair = 100; % e.g. # people making judgments
 % num opt = 5; % options
 %
 % count data = zeros(num opt);
 % for num=1:num judgments per pair
 % % Each person generates a new quality score for each pair
 % quality = normrnd(mu(:)*ones(1,num opt), sigma);
 % % Add a count for the higher quality option for each pair
 % count data = count data + bsxfun(@gt, quality, quality');
 % end

 % Paired comparison count data matrix.
 % This count data matrix was generated with the above code.
 % count data(i,j) is the number of times option i was
 % preferred over option j.
 count_data = [ 0 27 24 4 0
 73 0 29 10 8
 76 71 0 37 16
 96 90 63 0 32
 100 92 84 68 0 ];

 %=====================
 % Fix 0/1 proportions in the data
 % (for use with the least squares estimators)
 %=====================
 fixed count data = fix counts(count data);

 %=====================
 % Estimate scale values
 %=====================

 % Incomplete matrix, maximum likelihood, and MAP methods
 % don't require the 0/1 fixed data.

 % Z-score threshold for least squares incomplete matrix methods
 thresh = 2;

 % Least squares method, Thurstone model (Gaussian)
 % Least squares method should use fixed count data to
 % "solve" the 0/1 problem.
 % (Not using the fixed data results in estimates with +Inf or -Inf
 % scale values for any 0/1 proportion entries)
 S ls fixed = scale ls(fixed count data);

 % Incomplete Matrix solution for the Thurstone model (Gaussian)
 S inc = scale inc(count data, thresh);

 % Least squares method, BTL model (Logistic)
 % Least squares method should use fixed count data to
 % "solve" the 0/1 problem.
 % (Not using the fixed data results in estimates with +Inf or -Inf
 % scale values for any 0/1 proportion entries)
 S ls btl fixed = scale ls btl(fixed count data);

 % Incomplete Matrix solution for the BTL model (Logistic)
 S inc btl = scale inc btl(count data, thresh);

 % Maximum likelihood method
 % (Requires cvx)
 S ml = scale ml(count data);

 % Maximum a posteriori (MAP) method
 % (Requires cvx)
 S map = scale map(count data);

 %=====================
 % Plot results
 %=====================
 one = ones(size(S ls fixed));

 scatter(S ls fixed, -1*one, 'bx');
 hold on;
 scatter(S inc, -2*one, 'bo');

 scatter(S ls btl fixed, -3*one, 'gx');
 scatter(S inc btl, -4*one, 'go');

 scatter(S ml, -5*one, 'rx');
 scatter(S map, -6*one, 'rˆ');
 hold off;

 title('Scale values for different methods')
 xlabel('Scale values')
 ylabel('Methods')
 methods={'Least Squares (with 0/1 fixed data)', ...
 'Incomplete Matrix Solution',...
 'BTL model, Least Squares (with 0/1 fixed data)', ...
 'BTL model, Incomplete Matrix Solution',...
 'Maximum Likelihood', ...
 'Maximum A Posteriori Likelihood'};
 set(gca, 'YTick',-6:-1, 'YTickLabel', fliplr(methods));
 ylim([-7,0]);
 grid on;
