<<<<<<< HEAD:P2U.m
%All parameters in a matrix into one array

function unknwn = P2U

t_start  = evalin('base', 't_start');
t_period = evalin('base', 't_period');
t_offset = evalin('base', 't_offset');
t_scale  = evalin('base', 't_scale');

Ps_coef = evalin('base', 'Ps_coef');

Q = evalin('base', 'Q');

number_images = evalin('base','number_images');

for i = 1 : number_images
    unknwn( 1 , i) = t_start (i);
    unknwn( 2 , i) = t_period(i);
    unknwn( 3 , i) = t_offset(i);
    unknwn( 4 , i) = t_scale (i);
    unknwn( 5 , i) = Ps_coef(1 , 1 , i);
    unknwn( 6 , i) = Ps_coef(1 , 2 , i);
    unknwn( 7 , i) = Ps_coef(1 , 3 , i);
    unknwn( 8 , i) = Ps_coef(2 , 1 , i);
    unknwn( 9 , i) = Ps_coef(2 , 2 , i);
    unknwn(10 , i) = Ps_coef(2 , 3 , i);
    unknwn(11 , i) = Ps_coef(3 , 1 , i);
    unknwn(12 , i) = Ps_coef(3 , 2 , i);
    unknwn(13 , i) = Ps_coef(3 , 3 , i);
    unknwn(14 , i) = Q(1 , 1 , i);
    unknwn(15 , i) = Q(1 , 2 , i);
    unknwn(16 , i) = Q(1 , 3 , i);
    unknwn(17 , i) = Q(1 , 4 , i);
    unknwn(18 , i) = Q(2 , 1 , i);
    unknwn(19 , i) = Q(2 , 2 , i);
    unknwn(20 , i) = Q(2 , 3 , i);
    unknwn(21 , i) = Q(2 , 4 , i);
    unknwn(22 , i) = Q(3 , 1 , i);
    unknwn(23 , i) = Q(3 , 2 , i);
    unknwn(24 , i) = Q(3 , 3 , i);
    unknwn(25 , i) = Q(3 , 4 , i);
    unknwn(26 , i) = Q(4 , 1 , i);
    unknwn(27 , i) = Q(4 , 2 , i);
    unknwn(28 , i) = Q(4 , 3 , i);
    unknwn(29 , i) = Q(4 , 4 , i);
=======
%All parameters in a matrix into one array

function unknwn = P2U

t_start  = evalin('base', 't_start');
t_period = evalin('base', 't_period');
t_offset = evalin('base', 't_offset');
t_scale  = evalin('base', 't_scale');

Ps_coef = evalin('base', 'Ps_coef');

Q = evalin('base', 'Q');

number_images = evalin('base','number_images');

for i = 1 : number_images
    unknwn( 1 , i) = t_start (i);
    unknwn( 2 , i) = t_period(i);
    unknwn( 3 , i) = t_offset(i);
    unknwn( 4 , i) = t_scale (i);
    unknwn( 5 , i) = Ps_coef(1 , 1 , i);
    unknwn( 6 , i) = Ps_coef(1 , 2 , i);
    unknwn( 7 , i) = Ps_coef(1 , 3 , i);
    unknwn( 8 , i) = Ps_coef(2 , 1 , i);
    unknwn( 9 , i) = Ps_coef(2 , 2 , i);
    unknwn(10 , i) = Ps_coef(2 , 3 , i);
    unknwn(11 , i) = Ps_coef(3 , 1 , i);
    unknwn(12 , i) = Ps_coef(3 , 2 , i);
    unknwn(13 , i) = Ps_coef(3 , 3 , i);
    unknwn(14 , i) = Q(1 , 1 , i);
    unknwn(15 , i) = Q(1 , 2 , i);
    unknwn(16 , i) = Q(1 , 3 , i);
    unknwn(17 , i) = Q(1 , 4 , i);
    unknwn(18 , i) = Q(2 , 1 , i);
    unknwn(19 , i) = Q(2 , 2 , i);
    unknwn(20 , i) = Q(2 , 3 , i);
    unknwn(21 , i) = Q(2 , 4 , i);
    unknwn(22 , i) = Q(3 , 1 , i);
    unknwn(23 , i) = Q(3 , 2 , i);
    unknwn(24 , i) = Q(3 , 3 , i);
    unknwn(25 , i) = Q(3 , 4 , i);
    unknwn(26 , i) = Q(4 , 1 , i);
    unknwn(27 , i) = Q(4 , 2 , i);
    unknwn(28 , i) = Q(4 , 3 , i);
    unknwn(29 , i) = Q(4 , 4 , i);
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:Geo3o1_3_1/P2U.m
end