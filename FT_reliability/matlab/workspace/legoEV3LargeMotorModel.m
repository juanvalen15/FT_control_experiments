% lego ev3 large motor estimated parameters with speed control
b = 0.2895;
J = 0.0288;
K = 0.2964;
L = 0.0288;
R = 0.2895;

A = [0 1 0; ...
     0 -b/J K/J; ...
     0 -K/J -R/L];
B = [0; 0; 1/L];
C = [1 0 0];

