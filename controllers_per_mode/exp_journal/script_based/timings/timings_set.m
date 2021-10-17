%% Clear all values
% TODO: how to automatically clear current script variables before using
% them
clear sp_sequence S sp_indexes sp_sequence_s S_s sp_samples_in_Sp Splant
clear SP SP_baseline TDM_table_duration_s all_h s LQR_LPTV_sequence
clear sp_indexes_LPTV SP_LPTV LQR_LPTV_sequence


%% Control timing generator
% Platform parameters
F = 100e6;   % [Hz]
C = 4096;    % [clock cycles @ F]

nominal_sampling_period = 1e-3
application_delay       = 0.99 * nominal_sampling_period
Splant                  = 100e-6;
%--------------------------------------------------------------------------


% Applications parameters
% TDM_table: vector with the allocation of the slots to the control application. 1 = control, 0 = other applications
% Tpa: execution time in seconds of Ts+Tc+Ta+To
% ---------------------------------------
if (Do_SINGLE_RATE_PSO_NOMINAL == 1) || (Do_SINGLE_RATE_CT == 1) % FOR NOMINAL SAMPLING PERIOD 
    % dummy values just to use the nominal sampling period for the SR
    % nominal controller    
    TDM_table = [1 1];
    P         = 295904; % to at least fit T within the slot 
end

% ---------------------------------------
if EXP == 1
    TDM_table = [1 0 0 0 0 0 0 0 0 0];
    P         = 295904; % clock cycles
end
if EXP == 2
    TDM_table = [1 0 0 0 0 0 0 0 0 0];
    P         = 395904; % clock cycles
end
if EXP == 3
    TDM_table = [1 0 0 0 0 0 0 0 0 0];
    P         = 495904; % clock cycles
end
if EXP == 4
    TDM_table = [1 0 0 0 0 0 0 0 0 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 5
    TDM_table = [1 0 0 0 0 1 0 0 0 0];
    P         = 295904; % clock cycles
end
if EXP == 6
    TDM_table = [1 0 0 0 0 1 0 0 0 0];
    P         = 395904; % clock cycles
end
if EXP == 7
    TDM_table = [1 0 0 0 0 1 0 0 0 0];
    P         = 495904; % clock cycles
end
if EXP == 8
    TDM_table = [1 0 0 0 0 1 0 0 0 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 9
    TDM_table = [1 0 1 0 1 0 1 0 1 0];
    P         = 295904; % clock cycles
end
if EXP == 10
    TDM_table = [1 0 1 0 1 0 1 0 1 0];
    P         = 395904; % clock cycles
end
if EXP == 11
    TDM_table = [1 0 1 0 1 0 1 0 1 0];
    P         = 495904; % clock cycles
end
if EXP == 12
    TDM_table = [1 0 1 0 1 0 1 0 1 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 13
    TDM_table = [1 1 1 1 1 1 1 1 1 1];
    P         = 295904; % clock cycles
end
if EXP == 14
    TDM_table = [1 1 1 1 1 1 1 1 1 1];
    P         = 395904; % clock cycles
end
if EXP == 15
    TDM_table = [1 1 1 1 1 1 1 1 1 1];
    P         = 495904; % clock cycles
end
if EXP == 16
    TDM_table = [1 1 1 1 1 1 1 1 1 1];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 17
    TDM_table = [1 0 0 0 0 0];
    P         = 295904; % clock cycles
end
if EXP == 18
    TDM_table = [1 0 0 0 0 0];
    P         = 395904; % clock cycles
end
if EXP == 19
    TDM_table = [1 0 0 0 0 0];
    P         = 495904; % clock cycles
end
if EXP == 20
    TDM_table = [1 0 0 0 0 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 21
    TDM_table = [1 0 0 1 0 0];
    P         = 295904; % clock cycles
end
if EXP == 22
    TDM_table = [1 0 0 1 0 0];
    P         = 395904; % clock cycles
end
if EXP == 23
    TDM_table = [1 0 0 1 0 0];
    P         = 495904; % clock cycles
end
if EXP == 24
    TDM_table = [1 0 0 1 0 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 25
    TDM_table = [1 0 1 0 1 0];
    P         = 295904; % clock cycles
end
if EXP == 26
    TDM_table = [1 0 1 0 1 0];
    P         = 395904; % clock cycles
end
if EXP == 27
    TDM_table = [1 0 1 0 1 0];
    P         = 495904; % clock cycles
end
if EXP == 28
    TDM_table = [1 0 1 0 1 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 29
    TDM_table = [1 1 1 1 1 1];
    P         = 295904; % clock cycles
end
if EXP == 30
    TDM_table = [1 1 1 1 1 1];
    P         = 395904; % clock cycles
end
if EXP == 31
    TDM_table = [1 1 1 1 1 1];
    P         = 495904; % clock cycles
end
if EXP == 32
    TDM_table = [1 1 1 1 1 1];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 33
    TDM_table = [1 0];
    P         = 295904; % clock cycles
end
if EXP == 34
    TDM_table = [1 0];
    P         = 395904; % clock cycles
end
if EXP == 35
    TDM_table = [1 0];
    P         = 495904; % clock cycles
end
if EXP == 36
    TDM_table = [1 0];
    P         = 595904; % clock cycles
end
% ---------------------------------------
if EXP == 37
    TDM_table = [1 1];
    P         = 295904; % clock cycles
end
if EXP == 38
    TDM_table = [1 1];
    P         = 395904; % clock cycles
end
if EXP == 39
    TDM_table = [1 1];
    P         = 495904; % clock cycles
end
if EXP == 40
    TDM_table = [1 1];
    P         = 595902; % clock cycles
end
% ---------------------------------------
if EXP == 41
    TDM_table = [1];
    P         = 295904; % clock cycles
end
if EXP == 42
    TDM_table = [1];
    P         = 395904; % clock cycles
end
if EXP == 43
    TDM_table = [1 1];
    P         = 495904; % clock cycles
end
if EXP == 44
    TDM_table = [1];
    P         = 595902; % clock cycles
end
% ---------------------------------------














%% TDM 
TDM_SIZE                = length(TDM_table); % number of partition slots within TDM_table
slots                   = sum(TDM_table(:) == 1);

SP_baseline = (TDM_SIZE/slots) * (P+C) * (1/F);




TDM_table_duration      = TDM_SIZE * (P+C); % [clock cycles]
TDM_table_duration_s    = TDM_table_duration * (1/F); % [clock cycles]
Tpa_s                   = nominal_sampling_period; % T duration
Tpa                     = Tpa_s * F; % T for PA FRAMEWORK

% Sampling periods
S = zeros(1,TDM_SIZE+1); % vector initialization to store TDM_SIZE+1 possible sampling periods
for i = 1:TDM_SIZE+1
    if i == 1
        S(i) = Tpa;
    else
        S(i) = Tpa + (P - floor(P/Tpa)*Tpa) + (i-1)*C + (i-2)*P;
    end
end
S_s = S * (1/F);

% Finding sequence
TDM_sim = repmat(TDM_table, 1, 2);  % TDM periods to be simulated: 2
app_vec = ones(1,length(TDM_sim));  % vector to do bitwise AND with 1: 1 is the label for control application
app_dis = (TDM_sim == app_vec);     % vector with the distribution of control application slots
app_gap = find(app_dis == 1);       % vector with the gaps in between the control application slots

% vector with the gaps in between partition slots
j = 1;
for i = 1:length(app_dis)
    if app_dis(i) == 1
        app_gap_ext(1,i) = app_dis(i)*app_gap(j);
        j = j + 1;
    else
        app_gap_ext(1,i) = 0;
    end;
end;

% finding frequency of sampling periods
for i = 1:length(app_dis)
    if app_dis(i) == 1
        f(i) = floor( P/Tpa );
    else
        f(i) = 0;
    end;
end;


% sequence that contains necessary sampling period executions
sequence_temp = f(length(TDM_table)+1:end);
first_non_zero_index = find(sequence_temp, length(sequence_temp), 'first');
sequence = [f(1:length(TDM_table)) f(length(TDM_table)+1:length(TDM_table)+first_non_zero_index)];

sequence_executions_temp = sequence(sequence ~= 0);
sequence_executions = sequence_executions_temp(1:end-1);
distances = diff(find(sequence~=0));

sp_indexes = [];
for i = 1:length(distances)
    sp_indexes  = [sp_indexes ones(1,sequence_executions(i)-1) distances(i)+1];
end


%% Export to Simulink for PA simulation
sp_sequence         = S(sp_indexes);
sp_sequence_s       = S_s(sp_indexes);
sp_samples_in_Sp    = sp_sequence_s / Splant;
SP                  = unique(sp_sequence_s);         % vector with unique sampling periods
% SP_baseline         = TDM_table_duration_s; % baseline sampling period = TDM_table duration

% Export to Simulink for LMI simulation
sp_indexes
SP





%% -----------------------------------------------------------------------
% Parameters JOURNAL ------ LPTV control LQR BASED
% -----------------------------------------------------------------------
disp('-----------------------------------------------------');
disp('TO DO: configure sampling periods for lqr experiments');
disp('-----------------------------------------------------');

% Sensor to Actuation delay
T = application_delay;
% sensing intervals
all_h = SP;
% Sensing sequence for design
s = [];
for i = 1:length(sp_indexes)
    LQR_LPTV_sequence(i) = find(SP == S_s(sp_indexes(i)));
end
s{1} = LQR_LPTV_sequence;

% Export to Simulink for LPTV simulation
sp_indexes_LPTV = [1:length(s{1})]
SP_LPTV         = all_h
LQR_LPTV_sequence

