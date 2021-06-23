% Ending the program by threshold

function endthr

Sc = evalin('base', 'Sc');

% Thereshold defination
if Sc == 0
    ts = 0.5;
elseif Sc(1) > 0
    ts = 1;
end

%===== Termination by rmse of GCPs =====
if Sc == 0
    mgcp = evalin('base', 'mgcp');
    if abs(max(mgcp)) <= ts
        return
    end
    disp('|Termination by reaching desired GCP accuracy.|');
    
%===== Termination by rmse of ICPs =====
elseif Sc(1) > 0
    micp = evalin('base', 'micp');
    if abs(max(micp)) <= ts
        return
    end
    disp('|Termination by reaching desired ICP accuracy.|');
end

disp(' ---------------------------------------------');