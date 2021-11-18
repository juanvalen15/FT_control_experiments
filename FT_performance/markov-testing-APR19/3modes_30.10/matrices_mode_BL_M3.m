%% n = 1 : BL

%% transition matrix n=1 -> 2 states: Baseline mode 3
m_01_01 = 1-Pfm(3);
m_01_02 = Pfm(3);
m_02_01 = 0;
m_02_02 = 1;

t_01_01 = tm(3);
t_01_02 = tm(3);
t_02_01 = 0;
t_02_02 = 0;


M_BL_M3 = [
  m_01_01 m_01_02; ...
  m_02_01 m_02_02
];

T_BL_M3 = [
  t_01_01 t_01_02; ...
  t_02_01 t_02_02
];
