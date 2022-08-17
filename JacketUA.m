function OutputJacketUA = JacketUA(x, y, z)

D_jo = 13.9*0.01; % outer diameter of jacket (m)
D_ji = 11.2*0.01; % inner diameter of jacket (m)
Q_HTF = 15/1000/60; % flow rate of heat transfer fluid converted from 15L/min to m^3/s
diameter_HTF = 0.009525; %3/8 in I.D. tube converted to meter (m)
A_HTF = pi*(diameter_HTF)^2; % cross-sectional area (m^2)
v_HTF = Q_HTF/A_HTF; % velocity of heat transfer fluid (m/min)
row_mixture_HTF = 1079.97; % density of 50/50 EG/water at -5C (kg/m^3) from literature
mu_mixture_HTF = 10.28/1000; % viscosity of 50/50 EG/water at -5C (mPa*s) from literature converted Pa to mPa to kg/m*s^2
k_mixture_HTF = 0.35015; % thermal conductivity of 50/50 ethylene glycol/water at -5C (W/m*K)
Cp_mixture_jacket = 3.1689; % heat capcity of 50/50 water/ethylene glycol (J/g*K) from literature
H = 7130.7*V_reaxtion + 2.8862; % height of reaction mixture (m)

% Reynolds number (Re) - jacket side
Re_jacket = (D_jo - D_ji)*v_HTF*row_mixture_HTF/mu_mixture_HTF;

% prandtl number (Pr) - jacket side
Pr_jacket = Cp_mixture_jacket*mu_mixture_jacket/k_mixture_HTF;

% Re <= 800
h_o_smallRe = k_jacket*1.02*(Re_jacket^0.45)*(Pr_jacket^(1/3))*1^0.14*((D_jo - D_ji)/H)^0.4*(D_jo/D_ji)^0.8;

% Re>= 4000
h_o_large_Re = k_jacket*0.027*(Re_jacket^0.8)*(Pr_jacket^(1/3))*1^0.14*(1+3.5*(D_jo - D_ji)/((D_jo + D_ji)/2))/D_T;


OutputJacketUA = (h_o_smallRe + h_o_large_Re)/2;

end
