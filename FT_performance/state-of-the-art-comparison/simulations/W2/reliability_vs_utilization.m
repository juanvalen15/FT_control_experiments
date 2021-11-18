%% reliablity vs. utilization W2
clear all
close all
clc


%% faults list
F     = [0 1 2 3 4 5 6 7 8 9 10];
Y.w2  = (2*F)+1;

for i = 1:length(F)    
    j=1;
    if( F(i) <= 2^(j+1)-2 )
        Y.our(i) = 2^(j+1);
        m.our(i) = j;
    else
        while( F(i) > 2^(j+1)-2 )
            j=j+1;
        end
        Y.our(i) = 2^(j+1);
        m.our(i) = j;
    end    
end

figure;
plot(F,Y.w2,'-mo','MarkerSize',8); hold on;
plot(F,Y.our,'-bo','MarkerSize',8);
grid on;
xlabel('Faults');
ylabel('Y_i');
legend('w2', 'our');

%% timing properties [our work]
psi   = 3;
omega = 1;
hm    = 5*(psi+omega);

for i = 1:length(m.our)
    T.our(i) = 2^(i+1) * hm;
    D.our(i) = (2^(i+1) - 1)*hm + 4*omega;
    C.our(i) = D.our(i);
end



%% printing parameters
sprintf('F \t m \t Y.our \t Y.w2 \t Ci.our \t T.our \t D.our')
disp([F' m.our' Y.our' Y.w2' C.our' T.our' D.our'])








