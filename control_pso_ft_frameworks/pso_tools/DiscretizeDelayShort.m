function [Phi,Gamma]=DiscretizeDelayShort(Ac,Bc,delay,h)

[n,inp]=size(Bc);       % states, inputs

Phi_d=expm(Ac*h);
tau_prime=delay;
s = expm([[Ac Bc]*(h-tau_prime); zeros(inp,n+inp)]);
% Phi_0A = s(1:n,1:n); %this is only valid when tau_prime1=0

s2 = expm([[Ac Bc]*(h); zeros(inp,n+inp)]);
Gamma_1 = s2(1:n,n+1:n+inp)-s(1:n,n+1:n+inp);
Gamma_0 = s(1:n,n+1:n+inp);

%Augmented system


Phi=[Phi_d Gamma_1;...
    zeros(inp,n) zeros(inp)];

Gamma=[Gamma_0;
                  eye(inp)];

%if (rank(ctrb(Phi,Gamma)))~=length(Phi);    fprintf(2,'Warning: the output system is not fully controlable \n'); end
