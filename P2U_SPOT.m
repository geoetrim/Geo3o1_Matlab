%All parameters in a matrix into one array for SPOT 6&7

function unknwn = P2U_SPOT

Ps_coef       = evalin('base', 'Ps_coef');
Qn_coef       = evalin('base', 'Qn_coef');
number_images = evalin('base','number_images');

for i = 1 : number_images
    unknwn( 1 , i) = Ps_coef(1 , 1 , i);
    unknwn( 2 , i) = Ps_coef(1 , 2 , i);
    unknwn( 3 , i) = Ps_coef(1 , 3 , i);
    unknwn( 4 , i) = Ps_coef(2 , 1 , i);
    unknwn( 5 , i) = Ps_coef(2 , 2 , i);
    unknwn( 6 , i) = Ps_coef(2 , 3 , i);
    unknwn( 7 , i) = Ps_coef(3 , 1 , i);
    unknwn( 8 , i) = Ps_coef(3 , 2 , i);
    unknwn( 9 , i) = Ps_coef(3 , 3 , i);
    unknwn(10 , i) = Qn_coef(1 , 1 , i);
    unknwn(11 , i) = Qn_coef(1 , 2 , i);
    unknwn(12 , i) = Qn_coef(1 , 3 , i);
    unknwn(13 , i) = Qn_coef(2 , 1 , i);
    unknwn(14 , i) = Qn_coef(2 , 2 , i);
    unknwn(15 , i) = Qn_coef(2 , 3 , i);
    unknwn(16 , i) = Qn_coef(3 , 1 , i);
    unknwn(17 , i) = Qn_coef(3 , 2 , i);
    unknwn(18 , i) = Qn_coef(3 , 3 , i);
    unknwn(19 , i) = Qn_coef(4 , 1 , i);
    unknwn(20 , i) = Qn_coef(4 , 2 , i);
    unknwn(21 , i) = Qn_coef(4 , 3 , i);
end