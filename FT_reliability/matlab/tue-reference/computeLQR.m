function [K,N] = computeLQR(ssD,sample,Q,R,horizon, P_markov,PK1,x)

P(:,:,horizon) = PK1;

for lqr_ind = horizon:-1:2
    tmp_sum = 0;
    for i = 1:length(P_markov)
        At = ssD{i}.Aaug_controller;
        Bt = ssD{i}.Baug_controller;
        qtj = P_markov(i,sample);
        tmp_sum = tmp_sum + qtj*(Q + At'*P(:,:,lqr_ind)*At - At'*P(lqr_ind)*Bt*inv(R+Bt'*P(:,:,lqr_ind)*Bt)*Bt'*P(:,:,lqr_ind)*At);
    end
    P(:,:,lqr_ind-1) = tmp_sum;
end
[sZ,~] = size(ssD{sample}.Aaug_controller)
tmp = [ssD{sample}.Aaug_controller-eye(sZ), ssD{sample}.Baug_controller
       ssD{sample}.Caug_controller, 0]

size(tmp)
Nbig = inv(tmp)*[zeros(sZ,1); 1]
Nx = Nbig(1:5)
Nu = Nbig(6)
K = -inv(R + ssD{sample}.Baug_controller'*P(:,:,2)*ssD{sample}.Baug_controller)*ssD{sample}.Baug_controller'*P(:,:,2)*ssD{sample}.Aaug_controller
N = (Nu+K*Nx);
%u = K*x - (Nu + K*Nx)*1;