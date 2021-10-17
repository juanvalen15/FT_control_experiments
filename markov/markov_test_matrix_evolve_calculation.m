%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%%
n = 5;

fsw{1} = [1 1 1 1 1];
fsw{2} = [4 4 4 4 4];

for sequence = 1:1 %length(fsw)
    
    f = fsw{sequence};
    
    exp = 0;
    ps_granularity = 0.1;
    for Ps = 0.1:ps_granularity:0.9
        exp = exp + 1; % just a counter for Ps index
        
        for i = 1:n
            Pfm(i)  = nchoosek(2^(i+1), 2^(i+1) - 1) * ( Ps^( 2^(i+1) - 1 ) ) * ( 1 - Ps );
        end
        
        
        %% transition matrix n=1
        m01_01 = 1-Pfm(1);
        m01_02 = Pfm(1);
        m02_01 = 0;
        m02_02 = 1;
        
        M_N1 = [m01_01, m01_02;
            m02_01, m02_02];
        
        
        %% transition matrix n=2
        m01_01 = 0;
        m01_02 = Pfm(1);
        m01_03 = 1-Pfm(1);
        m01_04 = 0;
        m01_05 = 0;
        m01_06 = 0;
        m01_07 = 0;
        
        m02_01 = 0;
        m02_02 = 0;
        m02_03 = 0;
        m02_04 = 0;
        m02_05 = 1-Pfm(2);
        m02_06 = 0;
        m02_07 = Pfm(2);
        
        m03_01 = 0;
        m03_02 = 0;
        m03_03 = 0;
        m03_04 = (1-Pfm(1))^f(1);
        m03_05 = 0;
        m03_06 = 0;
        m03_07 = 1-(1-Pfm(1))^f(1);
        
        m04_01 = 0;
        m04_02 = 0;
        m04_03 = 1-Ps;
        m04_04 = 0;
        m04_05 = Ps;
        m04_06 = 0;
        m04_07 = 0;
        
        m05_01 = 0;
        m05_02 = 0;
        m05_03 = 0;
        m05_04 = 0;
        m05_05 = 0;
        m05_06 = (1-Pfm(2))^f(2);
        m05_07 = 1-(1-Pfm(2))^f(2);
        
        m06_01 = 0;
        m06_02 = 0;
        m06_03 = 1-Ps;
        m06_04 = 0;
        m06_05 = Ps;
        m06_06 = 0;
        m06_07 = 0;

        m07_01 = 0;
        m07_02 = 0;
        m07_03 = 0;
        m07_04 = 0;
        m07_05 = 0;
        m07_06 = 0;
        m07_07 = 1;        
        
        M_N2 = [m01_01 m01_02 m01_03 m01_04 m01_05 m01_06 m01_07; ...
                m02_01 m02_02 m02_03 m02_04 m02_05 m02_06 m02_07; ...
                m03_01 m03_02 m03_03 m03_04 m03_05 m03_06 m03_07; ...
                m04_01 m04_02 m04_03 m04_04 m04_05 m04_06 m04_07; ...
                m05_01 m05_02 m05_03 m05_04 m05_05 m05_06 m05_07; ...
                m06_01 m06_02 m06_03 m06_04 m06_05 m06_06 m06_07; ...
                m07_01 m07_02 m07_03 m07_04 m07_05 m07_06 m07_07];
        
        
        
        %% transition matrix n=3
        m01_01 = 0;
        m01_02 = Pfm(1);
        m01_03 = 0;
        m01_04 = 1-Pfm(1);
        m01_05 = 0;
        m01_06 = 0;
        m01_07 = 0;
        m01_08 = 0;
        m01_09 = 0;
        m01_10 = 0;
        
        
        m02_01 = 0;
        m02_02 = 0;
        m02_03 = Pfm(2);
        m02_04 = 0;
        m02_05 = 0;
        m02_06 = 1-Pfm(2);
        m02_07 = 0;
        m02_08 = 0;
        m02_09 = 0;
        m02_10 = 0;
        
        
        m03_01 = 0;
        m03_02 = 0;
        m03_03 = 0;
        m03_04 = 0;
        m03_05 = 0;
        m03_06 = 0;
        m03_07 = 0;
        m03_08 = 1-Pfm(3);
        m03_09 = 0;
        m03_10 = Pfm(3);
        
        m04_01 = 0;
        m04_02 = 0;
        m04_03 = 0;
        m04_04 = 0;
        m04_05 = (1-Pfm(1))^f(1);
        m04_06 = 0;
        m04_07 = 0;
        m04_08 = 0;
        m04_09 = 0;
        m04_10 = 1 - ( (1-Pfm(1))^f(1) );
        
        m05_01 = 0;
        m05_02 = 0;
        m05_03 = 0;
        m05_04 = 1-Ps;
        m05_05 = 0;
        m05_06 = Ps;
        m05_07 = 0;
        m05_08 = 0;
        m05_09 = 0;
        m05_10 = 0;
        
        m06_01 = 0;
        m06_02 = 0;
        m06_03 = 0;
        m06_04 = 0;
        m06_05 = 0;
        m06_06 = 0;
        m06_07 = (1-Pfm(2))^f(2);
        m06_08 = 0;
        m06_09 = 0;
        m06_10 = 1 - ( (1-Pfm(2))^f(2) );
        
        m07_01 = 0;
        m07_02 = 0;
        m07_03 = 0;
        m07_04 = 1-Ps;
        m07_05 = 0;
        m07_06 = 0;
        m07_07 = 0;
        m07_08 = Ps;
        m07_09 = 0;
        m07_10 = 0;
        
        m08_01 = 0;
        m08_02 = 0;
        m08_03 = 0;
        m08_04 = 0;
        m08_05 = 0;
        m08_06 = 0;
        m08_07 = 0;
        m08_08 = 0;
        m08_09 = (1-Pfm(3))^f(3);
        m08_10 = 1 - ( (1-Pfm(3))^f(3) );
        
        m09_01 = 0;
        m09_02 = 0;
        m09_03 = 0;
        m09_04 = 0;
        m09_05 = 0;
        m09_06 = 1-Ps;
        m09_07 = 0;
        m09_08 = Ps;
        m09_09 = 0;
        m09_10 = 0;
        
        m10_01 = 0;
        m10_02 = 0;
        m10_03 = 0;
        m10_04 = 0;
        m10_05 = 0;
        m10_06 = 0;
        m10_07 = 0;
        m10_08 = 0;
        m10_09 = 0;
        m10_10 = 1;
        
        
        M_N3 = [m01_01 m01_02 m01_03 m01_04 m01_05 m01_06 m01_07 m01_08 m01_09 m01_10; ...
            m02_01 m02_02 m02_03 m02_04 m02_05 m02_06 m02_07 m02_08 m02_09 m02_10; ...
            m03_01 m03_02 m03_03 m03_04 m03_05 m03_06 m03_07 m03_08 m03_09 m03_10; ...
            m04_01 m04_02 m04_03 m04_04 m04_05 m04_06 m04_07 m04_08 m04_09 m04_10; ...
            m05_01 m05_02 m05_03 m05_04 m05_05 m05_06 m05_07 m05_08 m05_09 m05_10; ...
            m06_01 m06_02 m06_03 m06_04 m06_05 m06_06 m06_07 m06_08 m06_09 m06_10; ...
            m07_01 m07_02 m07_03 m07_04 m07_05 m07_06 m07_07 m07_08 m07_09 m07_10; ...
            m08_01 m08_02 m08_03 m08_04 m08_05 m08_06 m08_07 m08_08 m08_09 m08_10; ...
            m09_01 m09_02 m09_03 m09_04 m09_05 m09_06 m09_07 m09_08 m09_09 m09_10; ...
            m10_01 m10_02 m10_03 m10_04 m10_05 m10_06 m10_07 m10_08 m10_09 m10_10];
        
        %%
        %         mc = dtmc(M_N3, 'StateNames', ["M1" "M2" "M3" "M4" "M5" "M6" "M7" "M8" "M9" "Instability"]);
        %
        %         rng(1); % For reproducibility
        %         numSteps = 2000;
        %         X0 = [1; 0; 0; 0; 0; 0; 0; 0; 0; 0]; % initial state
        %         X0(1) = 10; % 100 random walks starting from state 1 only
        %         X = simulate(mc,numSteps,'X0',X0);
        %
        %         figure;
        %         simplot(mc,X,'Type','transitions');
        
        %% transition matrix n=5
        m01_01 = 0;
        m01_02 = Pfm(1);
        m01_03 = 0;
        m01_04 = 0;
        m01_05 = 0;
        m01_06 = 1-Pfm(1);
        m01_07 = 0;
        m01_08 = 0;
        m01_09 = 0;
        m01_10 = 0;
        m01_11 = 0;
        m01_12 = 0;
        m01_13 = 0;
        m01_14 = 0;
        m01_15 = 0;
        m01_16 = 0;
        
        m02_01 = 0;
        m02_02 = 0;
        m02_03 = Pfm(2);
        m02_04 = 0;
        m02_05 = 0;
        m02_06 = 0;
        m02_07 = 0;
        m02_08 = 1-Pfm(2);
        m02_09 = 0;
        m02_10 = 0;
        m02_11 = 0;
        m02_12 = 0;
        m02_13 = 0;
        m02_14 = 0;
        m02_15 = 0;
        m02_16 = 0;
        
        m03_01 = 0;
        m03_02 = 0;
        m03_03 = 0;
        m03_04 = Pfm(3);
        m03_05 = 0;
        m03_06 = 0;
        m03_07 = 0;
        m03_08 = 0;
        m03_09 = 0;
        m03_10 = 1-Pfm(3);
        m03_11 = 0;
        m03_12 = 0;
        m03_13 = 0;
        m03_14 = 0;
        m03_15 = 0;
        m03_16 = 0;
        
        m04_01 = 0;
        m04_02 = 0;
        m04_03 = 0;
        m04_04 = 0;
        m04_05 = Pfm(4);
        m04_06 = 0;
        m04_07 = 0;
        m04_08 = 0;
        m04_09 = 0;
        m04_10 = 0;
        m04_11 = 0;
        m04_12 = 1-Pfm(4);
        m04_13 = 0;
        m04_14 = 0;
        m04_15 = 0;
        m04_16 = 0;
        
        m05_01  = 0;
        m05_02  = 0;
        m05_03  = 0;
        m05_04  = 0;
        m05_05  = 0;
        m05_06  = 0;
        m05_07  = 0;
        m05_08  = 0;
        m05_09  = 0;
        m05_10  = 0;
        m05_11  = 0;
        m05_12  = 0;
        m05_13  = 0;
        m05_14  = 1-Pfm(5);
        m05_15  = 0;
        m05_16  = Pfm(5);
        
        m06_01  = 0;
        m06_02  = 0;
        m06_03  = 0;
        m06_04  = 0;
        m06_05  = 0;
        m06_06  = 0;
        m06_07  = (1-Pfm(1))^f(1);
        m06_08  = 0;
        m06_09  = 0;
        m06_10  = 0;
        m06_11  = 0;
        m06_12  = 0;
        m06_13  = 0;
        m06_14  = 0;
        m06_15  = 0;
        m06_16  = 1 - (1-Pfm(1))^f(1);
        
        m07_01  = 0;
        m07_02  = 0;
        m07_03  = 0;
        m07_04  = 0;
        m07_05  = 0;
        m07_06  = 1-Ps;
        m07_07  = 0;
        m07_08  = Ps;
        m07_09  = 0;
        m07_10  = 0;
        m07_11  = 0;
        m07_12  = 0;
        m07_13  = 0;
        m07_14  = 0;
        m07_15  = 0;
        m07_16  = 0;
        
        m08_01  = 0;
        m08_02  = 0;
        m08_03  = 0;
        m08_04  = 0;
        m08_05  = 0;
        m08_06  = 0;
        m08_07  = 0;
        m08_08  = 0;
        m08_09  = (1-Pfm(2))^f(2);
        m08_10  = 0;
        m08_11  = 0;
        m08_12  = 0;
        m08_13  = 0;
        m08_14  = 0;
        m08_15  = 0;
        m08_16  = 1 - (1-Pfm(2))^f(2);
        
        m09_01  = 0;
        m09_02  = 0;
        m09_03  = 0;
        m09_04  = 0;
        m09_05  = 0;
        m09_06  = 1-Ps;
        m09_07  = 0;
        m09_08  = 0;
        m09_09  = 0;
        m09_10  = Ps;
        m09_11  = 0;
        m09_12  = 0;
        m09_13  = 0;
        m09_14  = 0;
        m09_15  = 0;
        m09_16  = 0;
        
        m10_01  = 0;
        m10_02  = 0;
        m10_03  = 0;
        m10_04  = 0;
        m10_05  = 0;
        m10_06  = 0;
        m10_07  = 0;
        m10_08  = 0;
        m10_09  = 0;
        m10_10  = 0;
        m10_11  = (1-Pfm(3))^f(3);
        m10_12  = 0;
        m10_13  = 0;
        m10_14  = 0;
        m10_15  = 0;
        m10_16  = 1 - (1-Pfm(3))^f(3);
        
        m11_01  = 0;
        m11_02  = 0;
        m11_03  = 0;
        m11_04  = 0;
        m11_05  = 0;
        m11_06  = 0;
        m11_07  = 0;
        m11_08  = 1-Ps;
        m11_09  = 0;
        m11_10  = 0;
        m11_11  = 0;
        m11_12  = Ps;
        m11_13  = 0;
        m11_14  = 0;
        m11_15  = 0;
        m11_16  = 0;
        
        m12_01  = 0;
        m12_02  = 0;
        m12_03  = 0;
        m12_04  = 0;
        m12_05  = 0;
        m12_06  = 0;
        m12_07  = 0;
        m12_08  = 0;
        m12_09  = 0;
        m12_10  = 0;
        m12_11  = 0;
        m12_12  = 0;
        m12_13  = (1-Pfm(4))^f(4);
        m12_14  = 0;
        m12_15  = 0;
        m12_16  = 1 - (1-Pfm(4))^f(4);
        
        m13_01  = 0;
        m13_02  = 0;
        m13_03  = 0;
        m13_04  = 0;
        m13_05  = 0;
        m13_06  = 0;
        m13_07  = 0;
        m13_08  = 0;
        m13_09  = 0;
        m13_10  = 1-Ps;
        m13_11  = 0;
        m13_12  = 0;
        m13_13  = 0;
        m13_14  = Ps;
        m13_15  = 0;
        m13_16  = 0;
        
        m14_01  = 0;
        m14_02  = 0;
        m14_03  = 0;
        m14_04  = 0;
        m14_05  = 0;
        m14_06  = 0;
        m14_07  = 0;
        m14_08  = 0;
        m14_09  = 0;
        m14_10  = 0;
        m14_11  = 0;
        m14_12  = 0;
        m14_13  = 0;
        m14_14  = 0;
        m14_15  = (1-Pfm(5))^f(5);
        m14_16  = 1 - (1-Pfm(5))^f(5);
        
        m15_01  = 0;
        m15_02  = 0;
        m15_03  = 0;
        m15_04  = 0;
        m15_05  = 0;
        m15_06  = 0;
        m15_07  = 0;
        m15_08  = 0;
        m15_09  = 0;
        m15_10  = 0;
        m15_11  = 0;
        m15_12  = 1-Ps;
        m15_13  = 0;
        m15_14  = Ps;
        m15_15  = 0;
        m15_16  = 0;
        
        m16_01  = 0;
        m16_02  = 0;
        m16_03  = 0;
        m16_04  = 0;
        m16_05  = 0;
        m16_06  = 0;
        m16_07  = 0;
        m16_08  = 0;
        m16_09  = 0;
        m16_10  = 0;
        m16_11  = 0;
        m16_12  = 0;
        m16_13  = 0;
        m16_14  = 0;
        m16_15  = 0;
        m16_16  = 1;
        
        
        
        
        M_N5 = [m01_01  m01_02  m01_03  m01_04  m01_05  m01_06  m01_07  m01_08  m01_09  m01_10  m01_11  m01_12  m01_13  m01_14  m01_15  m01_16; ...
            m02_01  m02_02  m02_03  m02_04  m02_05  m02_06  m02_07  m02_08  m02_09  m02_10  m02_11  m02_12  m02_13  m02_14  m02_15  m02_16; ...
            m03_01  m03_02  m03_03  m03_04  m03_05  m03_06  m03_07  m03_08  m03_09  m03_10  m03_11  m03_12  m03_13  m03_14  m03_15  m03_16; ...
            m04_01  m04_02  m04_03  m04_04  m04_05  m04_06  m04_07  m04_08  m04_09  m04_10  m04_11  m04_12  m04_13  m04_14  m04_15  m04_16; ...
            m05_01  m05_02  m05_03  m05_04  m05_05  m05_06  m05_07  m05_08  m05_09  m05_10  m05_11  m05_12  m05_13  m05_14  m05_15  m05_16; ...
            m06_01  m06_02  m06_03  m06_04  m06_05  m06_06  m06_07  m06_08  m06_09  m06_10  m06_11  m06_12  m06_13  m06_14  m06_15  m06_16; ...
            m07_01  m07_02  m07_03  m07_04  m07_05  m07_06  m07_07  m07_08  m07_09  m07_10  m07_11  m07_12  m07_13  m07_14  m07_15  m07_16; ...
            m08_01  m08_02  m08_03  m08_04  m08_05  m08_06  m08_07  m08_08  m08_09  m08_10  m08_11  m08_12  m08_13  m08_14  m08_15  m08_16; ...
            m09_01  m09_02  m09_03  m09_04  m09_05  m09_06  m09_07  m09_08  m09_09  m09_10  m09_11  m09_12  m09_13  m09_14  m09_15  m09_16; ...
            m10_01  m10_02  m10_03  m10_04  m10_05  m10_06  m10_07  m10_08  m10_09  m10_10  m10_11  m10_12  m10_13  m10_14  m10_15  m10_16; ...
            m11_01  m11_02  m11_03  m11_04  m11_05  m11_06  m11_07  m11_08  m11_09  m11_10  m11_11  m11_12  m11_13  m11_14  m11_15  m11_16; ...
            m12_01  m12_02  m12_03  m12_04  m12_05  m12_06  m12_07  m12_08  m12_09  m12_10  m12_11  m12_12  m12_13  m12_14  m12_15  m12_16; ...
            m13_01  m13_02  m13_03  m13_04  m13_05  m13_06  m13_07  m13_08  m13_09  m13_10  m13_11  m13_12  m13_13  m13_14  m13_15  m13_16; ...
            m14_01  m14_02  m14_03  m14_04  m14_05  m14_06  m14_07  m14_08  m14_09  m14_10  m14_11  m14_12  m14_13  m14_14  m14_15  m14_16; ...
            m15_01  m15_02  m15_03  m15_04  m15_05  m15_06  m15_07  m15_08  m15_09  m15_10  m15_11  m15_12  m15_13  m15_14  m15_15  m15_16; ...
            m16_01  m16_02  m16_03  m16_04  m16_05  m16_06  m16_07  m16_08  m16_09  m16_10  m16_11  m16_12  m16_13  m16_14  m16_15  m16_16];
        
        
        %%
        %         mc = dtmc(M_N5, 'StateNames', ["M1" "M2" "M3" "M4" "M5" "M6" "M7" "M8" "M9" "M10" "M11" "M12" "M13" "M14" "M15" "Instability"]);
        %
        %         rng(1); % For reproducibility
        %         numSteps = 2000;
        %         X0 = [1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 ;0 ;0 ;0 ;0]; % initial state
        %         X0(1) = 10; % 100 random walks starting from state 1 only
        %         X = simulate(mc,numSteps,'X0',X0);
        %
        %         figure;
        %         simplot(mc,X,'Type','transitions');
        
        
        %% iterations test
        LOOPS = 10000;
        
        clear state_N1 state_N3 state_N5
        
        state_N1(1,:) = [1 0]; % initialization in mode 1: 2 STATES
        state_N2(1,:) = [1 0 0 0 0 0 0]; % initialization in mode 1: 7 STATES
        state_N3(1,:) = [1 0 0 0 0 0 0 0 0 0]; % initialization in mode 1 10 STATES
        state_N5(1,:) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % initialization in mode 1: 16 STATES        
        
        for i = 2:LOOPS
            state_N1(i,:) = state_N1(i-1,:) * M_N1;
            state_N2(i,:) = state_N2(i-1,:) * M_N2;
            state_N3(i,:) = state_N3(i-1,:) * M_N3;
            state_N5(i,:) = state_N5(i-1,:) * M_N5;                       
        end
        
        %% settling time: estimatio of the probability of being reliable
        temp_reliability_N1 = 1-state_N1(:,2);
        temp_reliability_N2 = 1-state_N2(:,7);
        temp_reliability_N3 = 1-state_N3(:,10);
        temp_reliability_N5 = 1-state_N5(:,16);
        
        % Settling probability
        TH = 0.000000001;
        info_temp_N1     = stepinfo(temp_reliability_N1,'SettlingTimeThreshold',TH);
        info_temp_N2     = stepinfo(temp_reliability_N2,'SettlingTimeThreshold',TH);
        info_temp_N3     = stepinfo(temp_reliability_N3,'SettlingTimeThreshold',TH);
        info_temp_N5     = stepinfo(temp_reliability_N5,'SettlingTimeThreshold',TH);
        
        settling_temp_N1 = ceil(info_temp_N1.SettlingTime);
        settling_temp_N2 = ceil(info_temp_N2.SettlingTime);
        settling_temp_N3 = ceil(info_temp_N3.SettlingTime);
        settling_temp_N5 = ceil(info_temp_N5.SettlingTime);
        
        reliailibty_temp_N1 = temp_reliability_N2(settling_temp_N1);
        reliailibty_temp_N2 = temp_reliability_N2(settling_temp_N2);
        reliailibty_temp_N3 = temp_reliability_N3(settling_temp_N3);
        reliailibty_temp_N5 = temp_reliability_N5(settling_temp_N5);
        

        % Mean probability
%         reliailibty_temp_N1 = mean(temp_reliability_N1);
%         reliailibty_temp_N2 = mean(temp_reliability_N2);
%         reliailibty_temp_N3 = mean(temp_reliability_N3);
%         reliailibty_temp_N5 = mean(temp_reliability_N5);


        reliability_N1(exp) = reliailibty_temp_N1;
        reliability_N2(exp) = reliailibty_temp_N2;
        reliability_N3(exp) = reliailibty_temp_N3;
        reliability_N5(exp) = reliailibty_temp_N5;
        
    end
    
    reliability_array_N1{sequence} = reliability_N1;
    reliability_array_N2{sequence} = reliability_N2;
    reliability_array_N3{sequence} = reliability_N3;
    reliability_array_N5{sequence} = reliability_N5;
    
    
end




%%
% figure;
% subplot(1,2,1);
% plot(reliability_array_N1{1}, 'r-o'); hold on;
% plot(reliability_array_N3{1}, 'g-o'); hold on;
% plot(reliability_array_N3{2}, 'b-o'); hold on;
% plot(reliability_array_N5{1}, 'm-o'); hold on;
% plot(reliability_array_N5{2}, 'c-o'); hold on;
% ylabel('Reliability [probability of being operational]');
% xlabel('Ps [probability of fault at application slot]');
%
% labels = 0.1:0.05:0.9;
% set(gca, 'XTick', 1:length(labels)); % Change x-axis ticks
% set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
%
% grid on;
% grid minor;
%
% legend('Baseline: mode 1','n=3, f=[1 1 1]', 'n=3, f=[4 4 4]','n=5, f=[1 1 1]', 'n=5, f=[4 4 4]');
%
%
% subplot(1,2,2);
% plot(reliability_array_N5{1}, 'r-o'); hold on;
% plot(reliability_array_N5{2}, 'b-o'); hold on;
% ylabel('Reliability [probability of being operational]');
% xlabel('Ps [probability of fault at application slot]');
%
% labels = 0.1:0.05:0.9;
% set(gca, 'XTick', 1:length(labels)); % Change x-axis ticks
% set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
%
% grid on;
% grid minor;
%
% legend('n=5, f=[1 1 1]', 'n=5, f=[4 4 4]');

%%
figure;
% subplot(1,2,1);
% plot(reliability_array_N1{1}, 'r-o'); hold on;
plot(reliability_array_N2{1}, 'g-o'); hold on;
plot(reliability_array_N3{1}, 'b-o'); hold on;
plot(reliability_array_N5{1}, 'm-o'); hold on;
ylabel('Reliability [probability of being operational]');
xlabel('Ps [probability of fault at application slot]');

labels = 0.1:ps_granularity:0.9;
set(gca, 'XTick', 1:length(labels)); % Change x-axis ticks
set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.

grid on;
grid minor;

% legend('n=1','n=2','n=3','n=5');
legend('n=2','n=3','n=5');


% subplot(1,2,2);
% plot(reliability_array_N5{1}, 'm-o'); hold on;
% ylabel('Reliability [probability of being operational]');
% xlabel('Ps [probability of fault at application slot]');
% 
% labels = 0.1:ps_granularity:0.9;
% set(gca, 'XTick', 1:length(labels)); % Change x-axis ticks
% set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
% 
% grid on;
% grid minor;
% 
% legend('n=5, f=[1 1 1]');