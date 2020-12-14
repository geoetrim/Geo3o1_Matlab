% Checking whether the point "i" is a check point.
% Coded by Hüseyin TOPAN (BEÜ) December 2015 Zonguldak
% pid : Point ID
function c = cp (pid, Sc)

c = 0;

for k = 1 : length(Sc)
    if Sc(k) == pid
        h(k) = 1;
    else h(k) = 0;
    end
end

c = sum(h);