function [Phi,Gamma]=DiscretizeDelayLong(Ac,Bc,pipes,delay,h)
%ModelSystem create an augmented model for a pipelined implementation.
% usage  [Phi,Gamma]=DiscretizeDelayLong(Ac,Bc,pipes,delay,h)
% Róbinson Medina. September 2015

pipes_required=ceil(delay/h);    %reconfigured number of pipes for this sistem
tau_prime=mod(delay,h);
[n,inp]=size(Bc);       % states, inputs

    
Phi_d=expm(Ac*h); %discrete time representation without augmenting

s = expm([[Ac Bc]*(h-tau_prime); zeros(inp,n+inp)]);
s2 = expm([[Ac Bc]*(h); zeros(inp,n+inp)]);

Gamma_0 = s(1:n,n+1:n+inp);
Gamma_1 = s2(1:n,n+1:n+inp)-s(1:n,n+1:n+inp);

% augmented system
fill_1=eye(inp);           % identity

Phi=zeros(n+2*inp+(pipes-2)*inp,n+2*inp+(pipes-2)*inp);
Phi(1:n,1:n)=Phi_d;

offset=(pipes-pipes_required)*inp+n;  % how many zeros spaces are required in order to augment the system
Phi(1:n,offset+1:offset+inp)=Gamma_0;
Phi(1:n,offset+inp+1:offset+2*inp)=Gamma_1;
rows=n;
for cols=n+2*inp:inp:pipes*inp+n
    Phi(rows+1:rows+inp,cols:cols+inp-1)=fill_1;
    rows=rows+inp;
end
Gamma=zeros(n+pipes*inp,inp);
Gamma(n+(pipes-1)*inp+1:end,1:inp)=fill_1;
%if (rank(ctrb(Phi,Gamma)))~=length(Phi);    fprintf(2,'Warning: the output system is not fully controlable \n'); end