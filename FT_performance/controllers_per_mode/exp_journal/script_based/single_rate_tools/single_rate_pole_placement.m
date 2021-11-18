%% Single-rate poleplacement design

%% Desired poles set. Varying 0.1:0.1:0.9 
% big set
% desired_poles = 0.1 *(((dec2base(0:power(9,dim+1)-1,9) - '0') + 1));

% small set
desired_poles = [.1 .1 .1 .1 .1;
                 .2 .2 .2 .2 .2;
                 .3 .3 .3 .3 .3;
                 .4 .4 .4 .4 .4;
                 .5 .5 .5 .5 .5;
                 .6 .6 .6 .6 .6;
                 .7 .7 .7 .7 .7;
                 .8 .8 .8 .8 .8;
                 .9 .9 .9 .9 .9];
             

% variable for feasible poles set
feasible_poles_set       = [];
feasible_controllers_set = [];

for poles_loop_index = 1:length(desired_poles)
    %% PLATFORM AWARE
    % Pole-Placement: nominal sampling period!
    K{1}        = -acker( A_aug_baseline, B_aug_baseline, desired_poles(poles_loop_index,:) ); 
    Acl         = A_aug_baseline + B_aug_baseline*K{1};
    
    if (any(eig(Acl) < 1) == 0)
        disp('WARNING: poles outside of the unit circle');
    end

    feasible_poles_set = [feasible_poles_set; desired_poles(poles_loop_index,:)];
    feasible_controllers_set = [feasible_controllers_set; K];

end

%% SAVE
% SAVING CONTROLLERS
save(['output/feasible_controllers/feasible_controllers_single_rate_poleplacement.mat'],'feasible_controllers_set','feasible_poles_set');






