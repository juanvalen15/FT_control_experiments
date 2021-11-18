
function St= setim(Ac,Bc,K,F,R,delay,Ts,Sett)%,Sat_u)
% Setim finds the settling time of a continous time system with delay. This
% function uses a 2 step simulation to find the settling time: first step find the St with a long sample period and second with a small one.  
%
%
% St= setim(Ac,Bc,K,F,pipes,R,delay,Ts)
% Ac=continoues state matrix
% Bc=continous input matrix
% K= feedback gain
% F=feedforward gain
% R=reference
% delay= sensing delay
% Ts=controller sample period
% St= settling time
%
% R�binson Medina 
% Eindhoven University of Techonology
% J-2016; Updated March 2016. July 2016 Generalized for any system

assert(isa(Ac,'double'))
assert(all(size(Ac)<=[4 4]));
assert(isreal (Ac));
assert(isa(Bc,'double'));assert(all(size(Bc)<=[4 1]));assert(isreal (Bc));
assert(isa(K,'double'));assert(all(size(K)<=[1 12]));assert(isreal (K));
assert(isa(F,'double'),all(size(F)==[1 1]),isreal (F));
assert(isa(R,'double'),all(size(R)==[1 1]),isreal (R));
assert(isa(delay,'double'),all(size(delay)==[1 1]),isreal (delay));
assert(isa(Ts,'double'),all(size(Ts)==[1 1]),isreal (Ts));
assert(isa(Sett,'double'),all(size(Sett)==[1 1]),isreal (Sett));
%assert(isa(Sat_u,'double'));assert(all(size(Sat_u)==[1 2]));assert(isreal (Sat_u));

St=0;St1=0;%St2=0;

%% simulation for the system with original sample period.
[n,~]=size(Bc);states=1+n;
h=Ts;
[Phi,Gamma]=DiscretizeDelayShort(Ac,Bc,delay,h); % discrete time system
X_long=zeros(states,1);     %initialize the states variable.
X_long1=X_long;             %initialize the x(k+1) variable
X_stable=X_long;            %defines X_stable
stable=0;                   % number of samples the system remained in the setpoint
% exit=0;


Samples=10+2*round(Sett/Ts); % compute at least 10 samples
u_stable=zeros(Samples,1);   % 5 samples are requierd to stabilize
u_all=zeros(Samples,1);

for cont1=1:Samples
    X_long=X_long1;          % update the current sample. 
    u=K*X_long+F*R;    
    X_long1=Phi*X_long+Gamma*u;
%     u_all(cont1)=u;
%     if u(1)>Sat_u(1) % clipping
%         u(1)=Sat_u(1);
%     elseif u(1)<Sat_u(2)
%         u(1)=Sat_u(2);
%     end
    if  (X_long1(1)>R*0.98) && (X_long1(1)<R*1.02)% is the next state is in steady state?
        if stable==0 % first estable sample... save the previous one!
            X_stable=X_long;
            St1=(cont1-1)*Ts; % initial set point value. 
            u_stable(1:1)=X_stable(n+1:end);
        end
        stable=stable+1;
        if stable>1 % save all controller actions for simulating the system with small sample period
            u_stable(stable)=X_long(n+1,1);
        end
%         if stable==5 % the system remained in the setpoint for 5 samples..
%             %exit=1;
%             break       
%         end
    else
        stable=0;St1=0;u_stable=u_stable*0;
    end 
end


%% simulation for the system with reduced sample period. 
if St1==0
    fprintf(2,':');
    St=Inf;
else
%% CODE COMENTED TO ELEMINATE THE SECOND SIMULATION LOOP WITH FINER SAMPLING PERIODS
%    % u=K*X_stable+F*R;         %controller action for the whole cycle. 
%    resolution=5; % 420 number of samples within one cycle.
%     SamplePeriod=Ts/resolution;
%     ratio=round(Ts/SamplePeriod);
% %     ratio=420; %84
% %     SamplePeriod=Ts/ratio;  %sample period of the system with higher resolution
% %     resolution=round(delay/SamplePeriod);
% %     X_1=zeros(resolution+1,1);                        % iniitial value for states
% %     X_1(1)=X_stable(1);
% %     X_1(2:end)=X_stable(2);
% %     [Phi,Gamma]=DiscretizeDelayLong(Ac,Bc,resolution,delay,SamplePeriod);     % discretize system with short sample period. 
% %     
% % 
%      stable2=0;                   % number of samples the system remained in the setpoint
%   
%     %discretize with the new reduced sample period
%     [~,n] = size(Ac); 
%     [~,nb] = size(Bc); 
%     s = expm([[Ac Bc]*SamplePeriod; zeros(nb,n+nb)]);
%     Phi = Phi(1:n,1:n);
%     Gamma= s(1:n,n+1:n+nb);
%     
%     X_1=zeros(n,1);
%     X_1(1:n)=X_stable(1:n);
%    index=1;
%     for cont2=1:stable*ratio% run subsystem during an entire sample period with the same controller output.
%         %X=X_1;
%         X_1=Phi*X_1+Gamma*u_stable(index);
%         X_1(1)
%         if mod(cont2,ratio)==0 % we have gone one period further
%             index=index+1;
%         end
%         if  (X_1(1)>R*0.98) && (X_1(1)<R*1.02) % (X(1)>R*0.98) && (X(1)<R*1.02) && is the current and past X in steady state?
%             if stable2==0        % first stable sample
%                 St2=cont2*SamplePeriod;
%                 St=St1+St2;
%             end
%             stable2=stable2+1;
%             if stable2>=2*ratio % the system remained in the setpoint for 100 samples..
%                 break       
%             end
%         else
%             stable2=0;%St2=0;
%         end
%     end 
    St=St1+Ts;
end
if St==0
    fprintf('System is oscillating around set point \n');
    St=inf;
end


