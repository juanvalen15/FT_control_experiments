function [Phi,Gamma] = Discretize_no_delay(Ac,Bc, h) % discrete time system

C = [1 0 0 0];
D = 0;
sysc = ss(Ac, Bc, C, D);
sysd = c2d(sysc, h);
Phi   = sysd.a; 
Gamma = sysd.b; 