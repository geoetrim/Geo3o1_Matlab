% Ending the program by threshold

function endthr

gsd = evalin('base', 'gsd');
micp = evalin('base', 'micp');
%===== Termination by rmse of ICPs =====
if max(micp) <= 1.2 * gsd
    return
end
disp('|Termination by reaching desired ICP accuracy (1.2×GSD).|');
disp(' ---------------------------------------------');