%Linear interpolation of each line's attitude angle of SPOT 5,
%quaternions of SPOT 6&7, and satellite position of Pléiades Neo.
%Case for SPOT-5
%Reference: SPOT Handbook, page 36.
%Edited January 2009
%Older name was arpy.m

function a = linear_interpolation(attia, attit, t)

dt = attit (:) - t;

for i = 1 : length(attia(:, 1));
    if dt(i) <= 0;
    dtn(i) = dt(i);
    end
end

nti = length(dtn);

a = attia(nti) + (attia(nti + 1) - attia(nti)) * ((t - attit(nti)) / (attit(nti + 1) - attit(nti)));