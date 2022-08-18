%% Process-side heat transfer (h_i) calculations

% function inputs
% diglyme and Nh4OH fractions, reaction volume

% Reynolds number (Re)
D_impeller = 6.7*0.01; % diameter of impeller (m)
N = 300/60*2*3.14; % impeller speed in rps (300 rpm)

row_diglyme = 937; % density of diglyme (kg/m^3)
row_water = 1000; % density of water (kg/m^3)
row_NH4OH_15N = 880; % density of 15N NH4OH (kg/m^3)
row_NH4OH_10N = row_water*1/3+row_NH4OH_15N*2/3; % density of 10N NH4OH(kg/m^3)
row_mixture = fraction_diglyme*row_diglyme + fraction_NH4OH*row_NH4OH_10N;

mu_diglyme = 0.0002*T_diglyme^2 - 0.1408*T_diglyme + 24.591; % viscosity calculation from -5 to 60C
mu_NH4OH_26 = 0.0014*T_NH4OH^2 - 0.0658*T_NH4OH + 2.0518; % viscosity calculation from -10 to 25C

mu_mixture = exp(fraction_diglyme*log(mu_diglyme) + fraction_NH4OH_26*log(mu_NH4OH_26));

Re_process = D_impeller^2*N*row_mixture/mu_mixture;

% prandtl number (Pr)
Cp_diglyme = 279.84; % heat capacity of diglyme (J/mol*K) or 2.09 J/g*K
Cp_water = 75.38; % heat capacity of water (J/mol*K) or 4.184 J/g*K
Cp_NH4OH = 34.807*4.184; % heat capacity of ammonium hydroxide at 270K (J/mol*K)
Cp_mixture = fraction_diglyme*Cp_diglyme + fraction_NH4OH*Cp_NH4OH;

k_diglyme = 0.14; % thermal conductivity of diglyme (W/m*K)
k_NH4OH = 0.6; % thermal conductivity of NH4OH 9W/m*K) from Razif et al. 2015
k_12 = 2/(1/k_diglyme + 1/k_NH4OH);
phi_1 = fraction_diglyme*MolVol_diglyme/(fraction_diglyme*MolVol_diglyme + fraction_NH4OH*MolVol_NH4OH);
phi_2 = fraction_NH4OH*MolVol_NH4OH/(fraction_diglyme*MolVol_diglyme + fraction_NH4OH*MolVol_NH4OH);
k_mixture = phi_1^2*k_diglyme + 2*phi_1*phi_2*k_12 + phi_2^2*k_NH4OH; % from perry's handbook 2-370 ex. 36

mu_diglyme = 0.0002*T_diglyme^2 - 0.1408*T_diglyme + 24.591; % viscosity calculation from -5 to 60C
mu_NH4OH_26 = 0.0014*T_NH4OH^2 - 0.0658*T_NH4OH + 2.0518; % viscosity calculation from -10 to 25C

mu_mixture = exp(fraction_diglyme*log(mu_diglyme) + fraction_NH4OH_26*log(mu_NH4OH_26));

Pr_process = Cp_mixture*mu_mixture/k_mixture;

% Nusselt number (Nu)
D_T = 8.8*0.01; % internal diameter of tank (in m)
a = 0.74; % flat blade turbine

h_i = k_mixture*a*(Re_process^(2/3))*(Pr_process^(1/3))*1^0.14/D_T;



%% Jacket-side heat transfer (h_o) calculationos

% Reynolds number (Re)
D_jo = 13.9*0.01; % outer diameter of jacket (m)
D_ji = 11.2*0.01; % inner diameter of jacket (m)

Q_HTF = 15/1000/60; % flow rate of heat transfer fluid converted from 15L/min to m^3/s
diameter_HTF = 0.009525; %3/8 in I.D. tube converted to meter (m)
A_HTF = pi*(diameter_HTF)^2; % cross-sectional area (m^2)
v_HTF = Q_HTF/A_HTF; % velocity of heat transfer fluid (m/min)

row_mixture_HTF = 1079.97; % density of 50/50 EG/water at -5C (kg/m^3) from literature

mu_mixture_HTF = 10.28/1000; % viscosity of 50/50 EG/water at -5C (mPa*s) from literature converted Pa to mPa to kg/m*s^2

Re_jacket = (D_jo - D_ji)*v_HTF*row_mixture_HTF/mu_mixture_HTF;

% Prandtl number (Pr) 
% fraction_water = 0.5;
% fraction_EG = 0.5;
% MolVol_water = 
% MolVol_EG = 
% k_water = 0.598; % thermal conductivity of water (W/m*K)
% k_EG = 0.2476; % thermal conductivity of ethylene glycol (W/m*K)
% k_12_HTF = 2/(1/k_water + 1/k_EG);
% phi_1_HTF = fraction_water*MolVol_water/(fraction_water*MolVol_water + fraction_EG*MolVol_EG);
% phi_2_HTF = fraction_EG*MolVol_EG/(fraction_water*MolVol_water + fraction_EG*MolVol_EG);
% k_mixture_HTF = phi_1_HTF^2*k_water + 2*phi_1_HTF*phi_2_HTF*k_12_HTF + phi_2_HTF^2*k_EG; % from perry's handbook 2-370 ex. 36

k_mixture_HTF = 0.35015; % thermal conductivity of 50/50 ethylene glycol/water at -5C (W/m*K)

Cp_EG = 
Cp_water = 
Cp_mixture_jacket = 

mu_water = 
mu_EG = 
mu_mixture_HTF =

Pr_jacket = Cp_mixture_jacket*mu_mixture_jacket/k_mixture_HTF;

% Re>= 4000

h_o = k_jacket*0.027*(Re_jacket^0.8)*(Pr_jacket^(1/3))*1^0.14*(1+3.5*(D_jo - D_ji)/((D_jo + D_ji)/2))/D_T;


%
H_200mL = 2.8*0.01; % height of liquid in the tank with 200mL (m)
H_300mL = 4.1*0.01; % height of liquid in the tank with 300mL (m)
H_400mL = 5.6*0.01; % height of liquid in the tank with 400mL (m)

%% overall heat transfer coefficient (UA)

D_T = 8.8*0.01;
D_T_radius = 8.8*0.01/2; % internal radius of tank (in m)
A_i = 3.14*D_T_radius^2;

D_ji = 11.2*0.01;
D_ji_radius = D_ji/2; % inner radius of jacket (m)
A_o = 3.14*D_ji_radius^2;

H = 7130.7*V_reaxtion + 2.8862; % height of reaction mixture (m)
k_MOC = 1.06; % thermal conductivitiy of glass (W/m*K)

UA = 1/((1/(h_i*A_i)) + (1/(h_o*A_o)) + ((log(D_ji/2) - log(D_T/2))/(2*pi*H*k_MOC)));



