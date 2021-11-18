% function [Aa,Ba,Qa,Sa,Ra] = CTtoDTdelay(Ac,Bc,Qc,Rc,T,h) %delay T, period h
function [Aa,Ba,Qa,Ra] = CTtoDTdelay(Ac,Bc,Qc,Rc,T,h) %delay T, period h

nx = size(Ac,1); nu = size(Bc,2);

%system
Phi = @(tau) expm(Ac*tau);
Gam1 = @(tau) [eye(nx) , zeros(nx,nu)]*expm([[Ac Bc]*tau; zeros(nu,nx+nu)]) * [zeros(nx,nu) ; eye(nu)];
Gam2 = @(tau) Phi(tau-T)*Gam1(T);
Gam3 = @(tau) Gam1(tau-T);

% Gam1(h);
Ad = Phi(h);
Gd = Gam2(h);
Bd = Gam3(h);

%augmented system
Aa = [Ad Gd; zeros(nu,nx+nu)];
Ba = [Bd ; eye(nu)];


%cost function
Qint1 = @(s) [Phi(s) Gam1(s); zeros(nu,nx) eye(nu)]'*blkdiag(Qc,Rc)*[Phi(s) Gam1(s); zeros(nu,nx) eye(nu)];
Qint2 = @(s) [Phi(s) Gam2(s); zeros(nu,nx+nu)]'*blkdiag(Qc,Rc)*[Phi(s) Gam2(s); zeros(nu,nx+nu)];
% Sint = @(s) [Phi(s) Gam2(s); zeros(nu,nx+nu)]'*blkdiag(Qc,Rc)*[Gam3(s); eye(nu)];
Rint = @(s) [Gam3(s); eye(nu)]'*blkdiag(Qc,Rc)*[Gam3(s); eye(nu)];

Qd = zeros(nx+nu);
% Sd = zeros(nx+nu,nu);
Rd = zeros(nu);

ngrid = 1e4;
vt = 0:h/ngrid:h;

vTi = round((T/h)*length(vt)); % index of T


%Replace this section by quad.m?
a = 1/3;
b = 4/3;
c = 2/3;
% a = 1;
% b = a;
% c = a;
for i = 1:length(vt)
    if i <= vTi
        if i == 1 || i == vTi
            Qd = Qd + (h/ngrid)*a*Qint1(vt(i));
        else
            if mod(i,2) ==0 % even            
                Qd = Qd + (h/ngrid)*b*Qint1(vt(i));
            else % odd           
                Qd = Qd + (h/ngrid)*c*Qint1(vt(i));
            end
        end
    else % after T
        if i == vTi+1 || i == length(vt)
            Qd = Qd + (h/ngrid)*a*Qint2(vt(i));
%             Sd = Sd + (h/ngrid)*a*Sint(vt(i));
            Rd = Rd + (h/ngrid)*a*Rint(vt(i));
        else
            if mod(i,2) ==0 % even            
                Qd = Qd + (h/ngrid)*b*Qint2(vt(i));
%                 Sd = Sd + (h/ngrid)*b*Sint(vt(i));
                Rd = Rd + (h/ngrid)*b*Rint(vt(i));
            else % odd           
                Qd = Qd + (h/ngrid)*c*Qint2(vt(i));
%                 Sd = Sd + (h/ngrid)*c*Sint(vt(i));
                Rd = Rd + (h/ngrid)*c*Rint(vt(i));
            end
        end
    end

end

Qa = Qd;
% Sa = Sd;
Ra = Rd;
end
