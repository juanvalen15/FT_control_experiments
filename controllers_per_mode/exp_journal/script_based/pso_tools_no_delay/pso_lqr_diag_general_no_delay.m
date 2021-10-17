function [Q,R,best,GB,iters,time, St_array]=pso_lqr_diag_general_no_delay(Ac,Bc,Cc,Dc,h,m,Cp,Cg,w,iter,Sett,max_x,max_u)
% pso_lqr_diag uses PSO to find the diagonal of Q and R that minimizes the
% settling time the system Ac, Bc, Cc, Dc.
% Ac,Bc,Cc,Dc= continous time state and input matrices
% m=swarm size
% Cp,Cg= personal and global confindence
% w=inertia
% iter= number of iterations
% Sett= settling time of the open loop system. It is used to compute the
% settling time of the controller
% max_x=maximum deviation expected in all the states
% max_u=maximum deviation expected in u
%
% Robinson Medina 
% Eindhoven University of Techonology
% Feb-2016

tic
res=1e-3;           % resolution for swarm converged
[n,inp]=size(Bc);   % n=states, inp=inputs


states=length(Ac);             % number of states

% Ref=1;     % Reference

%% INITIALIZE PSO ALGORITHM

fprintf('\nInitializing PSO algorithm Cp=%1.1d Cg=%1.1d w=%1.0d m=%3.0d\n',Cp,Cg,w,m)

% using brysol method to generalize
X=cell(m,1);                    % Swarm definition
X_temp=zeros(states+inp,1);     % states for Q and inp for R matrices
for cont2=1:m 
    Q=([1./max_x]).*rand(states,1);
    R=(1/max_u)^2*rand(inp);
    X_temp(1:states)=Q; % using brysol to initialize
    X_temp(states+1:states+inp)=R;
    X{cont2}=X_temp; % save the values in the swarm
end

% initialize memory vectors and velocity
v=cell(m,1);v(:,1)={0}; % initial velocity

% initialize memory
X_pb=cell(m,2);     % personal best first column the X value and second column its fitness
X_gb=cell(1,2);     % Global best, first column the X value and second column its fitness

%initialize fitness
X_gb(1)={-Inf};
X_gb{1,2}=X{1}*0;
X_pb(:,1)={-Inf};
X_pb(:,2)=X;

%% Main PSO algorithm
fprintf('\nSimulating main PSO algorithm \n')
NoProgressIters=0;
for cont2=1:iter    
    if NoProgressIters>10   % no progress for 10 iterations, then stop the algorithm
        fprintf(2,'\nStopped due to lack of progress \n ');
        break
    end    
    NoProgressIters=NoProgressIters+1;
    diff=0; % stop criterion, if the total difference in fitness is less than a threshold it means that all the particles are pointing the same optimal, stop algorithm    
    St_array = [];
    for cont = 1:m                
        diagonal=X{cont}; % extract the values of the cell array. 
        Q=diag(diagonal(1:states)); % Q matrix LQR
        R=diag(diagonal(states+1:states+inp)); % R matrix LQR        
        try
            % CT
            K=-lqr(Ac,Bc,Q,R); % feedback gain
            F=1/(Cc*((-Ac-Bc*K)^-1)*Bc); % feedforward gain                        
            % DT
            %K=-dlqr(Phi,Gamma,Q,R); % feedback gain
            %F=inv(Cc/(eye(states)-Phi-Gamma*K)*Gamma); % feedforward gain            
                        
% My solution -------------------------------------------------------------            
            time_vector      = 0:(h*1000):Sett;
            reference_vector = ones(size(time_vector));                        
            x0 = [0;0;0;0]; % initial state 0
            
            %sys_CL_NF = ss(Ac+Bc*K,Bc,Cc,Dc); % CL: without feedfordward control
            sys_CL_WF = ss(Ac+Bc*K,Bc*F,Cc,Dc); % CL: with feedfordward control
            [y,t,~] = lsim(sys_CL_WF,reference_vector,time_vector,x0); % linear simulation CT            
            
            St_info = stepinfo(y);
            St = t(floor(St_info.SettlingTime));
%             St_array = [St_array St];
            
            
            catch ME % if the lqr could not stabilize the system, make the particle with infinite settling time. 
            fprintf(2,[ '\n' ME.message '\n'] )
            St=Inf;
        end        
        fitness=-St; % PSO fitness, the larger the better       
        % update global best
        if fitness>X_gb{1}
            X_gb(1,1)={fitness}; % update fitness time
            X_gb(1,2)=X(cont);   % update X value.
            fprintf('\nGb=%d \n',-X_gb{1,1})
            NoProgressIters=0;
        end        
        % Update personal best
         if fitness>X_pb{cont,1}
            X_pb(cont,1)={fitness}; % update fitness time
            X_pb(cont,2)=X(cont);   % update X value.
            slowest=-min([X_pb{:,1}]); % slowest particle in the swarm
% My solution - do not modify the Settling time Sett
%             if Sett>(slowest/2)
%                 Sett=slowest/2;fprintf('~'); % there is no need of evaluating the settling time further than this point
%             end
         end
          diff=diff+X_gb{1,1}-X_pb{cont,1}; % update stop criterion: all the personal best are more or less equal, there is no way to go now.                        
    end
    if (diff<=res) && (diff>=-res)
        fprintf('\nconverged! at iter %d \n',cont2)
        break
    end


    for cont=1:m  % update speed and swarm
        v{cont,1}=w*v{cont,1}+Cp*rand(1)*(X_pb{cont,2}-X{cont})+Cg*rand(1)*(X_gb{1,2}-X{cont});     
        % check for constrain violation
        for count=1:states+inp  % check for constrain violation
            if (X{cont}(count)<1e-6) &&  (v{cont,1}(count)<0) %the position of the particle is already too small and the speed will try to decrease it. This avoids resolution problems
                v{cont,1}(count)=0; %reset speed
            else
                while (X{cont}(count)+v{cont,1}(count))<0 %check if there is going to be constraint violation
                    v{cont,1}(count)=v{cont,1}(count)*w; % decrease speed before it violates the constraints
                end
                X{cont}(count)= X{cont}(count)+v{cont,1}(count); % update the swarm
            end
        end
    end
    
    %progress printing
    if mod(cont2,10)==0
        fprintf('\n %d/%d ',cont2,iter) %new line
    end
end

diagonal=X_gb{2};    
Q=diagonal(1:states); % Q matrix LQR
R=diagonal(states+1:states+inp);
fprintf('\nfinished: global best=%d, \n', -X_gb{1});

time=toc;
iters=cont2;
best=X_gb{2};
GB=-X_gb{1};