%% PLANT DISCRETIZATION AND AUGMENTATION
for i = 1:length(S)
    hs      = S(i);
    delay   = delays(i);
    sysd    = c2d(sysc, hs); 

    Ad{i} = sysd.a; 
    Bd{i} = sysd.b; 
    Cd{i} = sysd.c;

    sysd_b0 = c2d(sysc, hs-delay); 
    sysd_b1 = c2d(sysc, hs); 
    B_0{i} = sysd_b0.b;
    B_temp = sysd_b1.b;
    B_1{i} = B_temp - B_0{i};

    A_aug{i} = [Ad{i}  B_1{i}; zeros(1,dim+1)];
    B_aug{i} = [B_0{i}; 1];
    C_aug{i} = [Cd{i} 0];
    D_aug{i} = 0;
end;

%% clear unecessary variables
clear i hs delay sysd Ad Bd Cd sysd_b0 sysd_b1 B_0 B_1 B_temp 