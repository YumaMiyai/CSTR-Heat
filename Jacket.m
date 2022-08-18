function h_o = Jacket(H)

D_jo = 13.9*0.01; % outer diameter of jacket (m)
D_ji = 11.2*0.01; % inner diameter of jacket (m)
Q_HTF = 15/1000/60; % flow rate of heat transfer fluid converted from 15L/min to m^3/s
diameter_HTF = 0.009525; %3/8 in I.D. tube converted to meter (m)
A_HTF = pi*(diameter_HTF)^2; % cross-sectional area (m^2)
v_HTF = Q_HTF/A_HTF/60; % velocity of heat transfer fluid (m/s)
row_mixture_HTF = 1079.97*1000; % density of 50/50 EG/water at -5C (g/m^3) from literature, unit conversion from kg/m^3
mu_mixture_HTF = 10.28/1000*1000; % viscosity of 50/50 EG/water at -5C (g/m*s) from literature converted mPa to Pa to kg/m*s^2 to g/m*s^2 (originally mPa*s)
k_mixture_HTF = 0.35015; % thermal conductivity of 50/50 ethylene glycol/water at -5C (W/m*K)
Cp_mixture_jacket = 3.1689; % heat capcity of 50/50 water/ethylene glycol (J/g*K) from literature

% Reynolds number (Re) - jacket side: m*(m/s)*(g/m^3)/(g/m*s)
Re_jacket = (D_jo - D_ji)*v_HTF*row_mixture_HTF/mu_mixture_HTF;

% prandtl number (Pr) - jacket side: (J/g*K)*(g/m*s)/(J/m*s*K)
Pr_jacket = Cp_mixture_jacket*mu_mixture_jacket/k_mixture_HTF;

% h_o calculation for Re <= 800: (J/m*K)/m = J/m^2*K
h_o_smallRe = k_jacket*1.02*(Re_jacket^0.45)*(Pr_jacket^(1/3))*1^0.14*((D_jo - D_ji)/H)^0.4*(D_jo/D_ji)^0.8/D_ji;

% h_o calculation for Re>= 4000: (J/m*K)/m = J/m^2*K
h_o_large_Re = k_jacket*0.027*(Re_jacket^0.8)*(Pr_jacket^(1/3))*1^0.14*(1+3.5*(D_jo - D_ji)/((D_jo + D_ji)/2))/D_ji;

h_o = (h_o_smallRe + h_o_large_Re)/2;

end
