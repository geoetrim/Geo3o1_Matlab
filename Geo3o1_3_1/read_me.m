% Readme file for Geo301
% Recoded by Hüseyin Topan, BEÜ, 2015

GCP file

 1 nn     <= input values
 2 x      <= input values (line)
 3 y      <= input values (column)
 4 X      <= input values
 5 Y      <= input values
 6 Z      <= input values
 7 x-xo   <= added by program
 8 y-yo   <= added by program
 9 ti     <= added by program (time of each line)
10 Xs     <= added by program (Approx. position of principle point for each line)
11 Ys     <= added by program (                           "                     ) 
12 Zs     <= added by program (			    			  "                     )
13 ~X and X <= added by program (~X for bundle adjustment in first iteration (this value might be estimated via raw parameters or pre-adjusted LOS angles), X: corrected value)
14 ~Y and Y <= added by program (~Y for bundle adjustment in first iteration (this value might be estimated via raw parameters or pre-adjusted LOS angles), Y: corrected value)
15 ~Z and Z <= added by program (~Z for bundle adjustment in first iteration (this value might be estimated via raw parameters or pre-adjusted LOS angles), Z: corrected value)
16 tan(psiy) <= added by program
17 tan(psix) <= added by program
18 psiy <= added by program
19 psix <= added by program

Satellite position & velocity file:
 1 time (second)
 2 X
 3 Y
 4 Z
 5 Vx 
 6 Vy
 7 Vz
 
 Parameters
 1 = t_start 
 2 = t_period
 3 = t_offset
 4 = t_scale 
 5 = Xs0     
 6 = Xs1     
 7 = Xs2     
 8 = Ys0     
 9 = Ys1     
10 = Ys2     
11 = Zs0     
12 = Zs1     
13 = Zs2     
14 = Q0_0    
15 = Q0_1    
16 = Q0_2    
17 = Q0_3    
18 = Q1_0    
19 = Q1_1    
20 = Q1_2    
21 = Q1_3    
22 = Q2_0    
23 = Q2_1    
24 = Q2_2    
25 = Q2_3    
26 = Q3_0    
27 = Q3_1    
28 = Q3_2    
29 = Q3_3    
30 = X       
31 = Y       
32 = Z       