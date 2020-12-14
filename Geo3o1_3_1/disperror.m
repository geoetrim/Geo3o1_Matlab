% Terminating/alerting via an error type
% Recoded by Hüseyin Topan, November 2017, BEÜ, Zonguldak

function disperror

rank_AEOP = evalin('base', 'rank_AEOP');
points    = evalin('base', 'points');
Sp        = evalin('base', 'Sp');

fprintf(' -------------------------------------------------------\n');
if rank_AEOP < size(points(1 , 1 , :)) * length(Sp)
    fprintf('| Error: Two or more parameters are linearly dependent! |\n');
    fprintf(fid,' Rank of A:          %5d\n Number of unknowns: %5d\n', rank(AEOP), 2 * length(Sp));

% if e == 1    
%     fprintf('| Bundle adjustment is not available!                   |\n');
%     fprintf('| No parameter or check point for bundle adjustment!    |\n');
    
fprintf('| Program terminated! So sorry, be happy :)             |\n');
fprintf(' -------------------------------------------------------\n');
end