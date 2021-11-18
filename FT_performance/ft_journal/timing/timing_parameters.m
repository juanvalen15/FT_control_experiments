%% TIMING PARAMETERS

%% PLATFORM OP FREQUENCY AND PLANT SIM. SAMPLING PERIOD
Fs = 100e6;     % platform operation frequency 100 MHz
hp = 100e-6;    % plant simulation sampling period

%% TDM properties
PS_array = [95904, 295904, 995904]; %Sm = 5ms, 15ms, 50ms
PS = PS_array(controller_experiment); % SELECT PS DEPENDING ON THE EXPERIMENT
CS = 4096; % comik slots

%% Controller modes sampling periods
Sm = 5*(PS+CS) * (1/Fs); % minimum sampling period
% S1 = 2*Sm;
% S2 = 4*Sm;
% S3 = 8*Sm;

% S1 = 4*Sm;
% S2 = 8*Sm;
% S3 = 16*Sm;
% S4 = 32*Sm;


%% Delays
% D1 = Sm    + (4*CS * 1/Fs);  
% D2 = 3*Sm  + (4*CS * 1/Fs);  
% D3 = 7*Sm  + (4*CS * 1/Fs);  

% D1 = 3*Sm   + (4*CS * 1/Fs);  
% D2 = 7*Sm   + (4*CS * 1/Fs);  
% D3 = 15*Sm  + (4*CS * 1/Fs);  
% D4 = 31*Sm  + (4*CS * 1/Fs);  

%% Rounding up delay to be used in CompSOC HIL simulation @ HP period
% Ts_1            = S1;
% delay_count_1   = ceil( D1/hp );
% delay_1         = delay_count_1 * hp;
% 
% Ts_2            = S2;
% delay_count_2   = ceil( D2/hp );
% delay_2         = delay_count_2 * hp;
% 
% Ts_3            = S3;
% delay_count_3   = ceil( D3/hp );
% delay_3         = delay_count_3 * hp;

%% Arrays with sets of timing parameters
for i = 1:control_modes
   S(i)                  = 2^(i+1) * Sm;
   D_array(i)            = (2^(i+1) - 1)*Sm + (4 * CS)*(1/Fs);
   delay_count_array(i)  = ceil( D_array(i)/hp );
   delays(i)             = delay_count_array(i) * hp;
   actuation_delays(i)   = delays(i) - (2^(i+1) - 1)*Sm;
end

% S       = [S1 S2 S3];
% delays  = [delay_1 delay_2 delay_3];

% D_array           = [D1 D2 D3];
% delay_count_array = [delay_count_1 delay_count_2 delay_count_3]; 
% Ts_array          = [Ts_1 Ts_2 Ts_3];

%% Actuation delays: added to the model to make it more realistic
% actuation_delays = [delays(1)-Sm delays(2)-(2*Sm) delays(3)-(6*Sm)];



%% Clear unecessary variables
% clear S1 S2 S3 delay_1 delay_2 delay_3 D1 D2 D3 delay_count_1 delay_count_2 delay_count_3 Ts_1 Ts_2 Ts_3