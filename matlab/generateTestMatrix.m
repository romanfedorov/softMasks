obs = [0:0.005:0.2 0.8:0.005:1];
n = length(obs);
m = zeros(n, n);

%generate all observations
for i = 1:n
    for ii = 1:n
        for iii = 1:3
            if i == ii
                continue;
            end
            r = rand * 2 - 1;
            if (obs(i) - obs(ii) > r)
                m(i,ii) = m(i,ii) + 1;
            else
                m(ii,i) = m(ii,i) + 1;
            end
        end
    end
end
obs
temp
y'
mean(abs(obs-y'))