% Estimation Ps(1)-Ps(2) via EOPs
%Coded by Hüseyin Topan, BEÜ, 2015

function Ps = est_Ps(unknwn, dx1, dx2)

dx = [dx1 dx2];

for i = 1 : 2
    Ps_1 = reshape(unknwn(5 : 13 , i), [3 , 3]);
    Ps_pre(: , : , i) = Ps_1';

    for k = 1 : 3 
        for l = 1 : 3
            P(l) = Ps_pre(k , l , i) * dx(i)^(l-1);
        end
        Ps(k , i) = sum(P);
        clear P
    end
end