%Finding the line-number of check point (2nd version)
%Example gcp: point ID, Sc: check point ID
%gcp = [23 56 78 90 67 27]'
%Sc  = [56 78 67]
%fc  = [2 3 5]
%Coded by Hüseyin TOPAN (BEÜ) December 2015

function fc = fndchk (Sc, gcp)

gcp = gcp(: , 1);

if Sc == 0
    fc = 0;
else
    for i = 1 : length(Sc)
        [r c] = find(gcp == Sc(i));
        fc(i) = r;
    end
end