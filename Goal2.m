clearvars
out = zeros(1000000,1);
for i=1:100
    for j=1:100
        for k=1:100
            ind = (i - 1) .* 10000 + (j - 1) .* 100 + k;
            out(ind) = ind;
        end
    end
end