%% n = 5

%% transition matrix n=5 -> 14 states

% initialization
states = 14;

m = zeros(states,states);
t = zeros(states,states);


% probabilities
m(1,2) = Pfm(1);
m(1,6) = 1-Pfm(1);

m(2,3) = Pfm(2);
m(2,7) = 1-Pfm(2);

m(3,4) = Pfm(3);
m(3,8) = 1-Pfm(3);

m(4,5) = Pfm(4);
m(4,9) = 1-Pfm(4);

m(5,10) = 1-Pfm(5);
m(5,14) = Pfm(5);

m(6,6) = 1-(x(1)+y(1));
if f(1)-1 == 0
  m(6,7) = 1-Pfm(1);
  m(6,14) = Pfm(1);
else
  m(6,7) = x(1);
  m(6,14) = y(1);
end

m(7,7) = 1-(x(2)+y(2));
if f(2)-1 == 0
    m(7,11) = 1-Pfm(2);
    m(7,14) = Pfm(2);
else
    m(7,11) = x(2);
    m(7,14) = y(2);
end


m(8,8) = 1-(x(3)+y(3));
if f(3)-1 == 0
    m(8,12) = 1-Pfm(3);
    m(8,14) = Pfm(3);
else
    m(8,12) = x(3);
    m(8,14) = y(3);    
end


m(9,9) = 1-(x(4)+y(4));
if f(4)-1 == 0
    m(9,13) = 1-Pfm(4);
    m(9,14) = Pfm(4);
else
    m(9,13) = x(4);
    m(9,14) = y(4);    
end

m(10,10) = 1-(x(5)+y(5));
if f(5)-1 == 0
    m(10,9)  = 1-Pfm(5);
    m(10,14) = Pfm(5);
else
    m(10,9)  = x(5);
    m(10,14) = y(5);    
end

m(11,6) = 1-Pfm(2);
m(11,8) = Pfm(2);

m(12,7) = 1-Pfm(3);
m(12,9) = Pfm(3);

m(13,8) = 1-Pfm(4);
m(13,10) = Pfm(4);

m(14,14) = 1;

M_N5 = m;


    
% time    
t(1,2) = tm(1);
t(1,6) = tm(1);

t(2,3) = tm(2);
t(2,7) = tm(2);

t(3,4) = tm(3);
t(3,8) = tm(3);

t(4,5) = tm(4);
t(4,9) = tm(4);

t(5,10) = tm(5);
t(5,14) = tm(5);

if f(1)-1 == 0
  t(6,6) = tm(1);
  t(6,7)  = tm(1);
  t(6,14) = tm(1);
else
  t(6,6) = tm(1) * (f(1)-1);
  t(6,7) = tm(1) * (f(1)-1);
  t(6,14) = tm(1) * (f(1)-1);
end

if f(2)-1 == 0
    t(7,7) = tm(2);
    t(7,11) = tm(2);
    t(7,14) = tm(2);
else
    t(7,7) = tm(2) * (f(2)-1);
    t(7,11) = tm(2) * (f(2)-1);
    t(7,14) = tm(2) * (f(2)-1);
end


if f(3)-1 == 0
    t(8,8) = tm(3);
    t(8,12) = tm(3);
    t(8,14) = tm(3);
else
    t(8,8) = tm(3) * (f(3)-1);
    t(8,12) = tm(3) * (f(3)-1);
    t(8,14) = tm(3) * (f(3)-1);
end


if f(4)-1 == 0
    t(9,9) = tm(4);
    t(9,13) = tm(4);
    t(9,14) = tm(4);
else
    t(9,9) = tm(4) * (f(4)-1);
    t(9,13) = tm(4) * (f(4)-1);
    t(9,14) = tm(4) * (f(4)-1);
end


if f(5)-1 == 0
    t(10,10) = tm(5);
    t(10,9)  = tm(5);
    t(10,14) = tm(5);
else
    t(10,10) = tm(5) * (f(5)-1);
    t(10,9)  = tm(5) * (f(5)-1);
    t(10,14) = tm(5) * (f(5)-1);
end


t(11,6) = tm(2);
t(11,8) = tm(2);

t(12,7) = tm(3);
t(12,9) = tm(3);

t(13,8) = tm(4);
t(13,10) = tm(4);



T_N5 = t;
