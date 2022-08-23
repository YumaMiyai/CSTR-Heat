function h_i = Process(T, fraction_diglyme, fraction_NH4OH, MolVol_diglyme, MolVol_NH4OH)

D_impeller = 6.7*0.01; % diameter of impeller (m)
N = 500/60*2*3.14; % impeller speed in rps (unit conversion from 300 rpm)
row_diglyme = 937; % density of diglyme (kg/m^3)
row_NH4OH_15N = 880; % density of 15N NH4OH (kg/m^3)
row_water = 1000; % density of water (kg/m^3)
row_NH4OH_10N = row_water*1/3+row_NH4OH_15N*2/3; % density of 10N NH4OH(kg/m^3)
row_mixture = (fraction_diglyme*row_diglyme + fraction_NH4OH*row_NH4OH_10N)*1000; % density of reaction mixture unit conversion from kg/m^3 to g/m^3
mu_diglyme = (112.96*exp(-0.016*T))/1000*1000; % viscosity calculation from -5 to 60C converting from mPa*s to Pa*s to kg/m*s to g/m*s
mu_NH4OH_26 = (0.0014*T^2 - 0.0658*T + 2.0518)/1000*1000; % viscosity calculation from -10 to 25C converting from mPa*s to Pa*s to kg/m*s to g/m*s
mu_mixture = exp(fraction_diglyme*log(mu_diglyme) + fraction_NH4OH*log(mu_NH4OH_26)); % (g/m*s)
Cp_diglyme = 2.09; % heat capacity of diglyme (J/g*K) or 279.84 J/mol*K
%Cp_water = 75.38; % heat capacity of water (J/mol*K) or 4.184 J/g*K
Cp_NH4OH = 34.807*4.184/35.04; % heat capacity of ammonium hydroxide at 270K unit conversion from cal/mol*K (J/g*K)
Cp_mixture = fraction_diglyme*Cp_diglyme + fraction_NH4OH*Cp_NH4OH; %(J/g*K)
k_diglyme = 0.14; % thermal conductivity of diglyme (W/m*K)
k_NH4OH = 0.6; % thermal conductivity of NH4OH (W/m*K) from Razif et al. 2015
k_12 = 2/(1/k_diglyme + 1/k_NH4OH);
phi_1 = fraction_diglyme*MolVol_diglyme/(fraction_diglyme*MolVol_diglyme + fraction_NH4OH*MolVol_NH4OH);
phi_2 = fraction_NH4OH*MolVol_NH4OH/(fraction_diglyme*MolVol_diglyme + fraction_NH4OH*MolVol_NH4OH);
k_mixture = phi_1^2*k_diglyme + 2*phi_1*phi_2*k_12 + phi_2^2*k_NH4OH; % from perry's handbook 2-370 ex. 36 (W/m*K)
D_T = 8.8*0.01; % internal diameter of tank (in m)
a = 0.74; % flat blade turbine

% Reynolds number (Re) - (m^2*1/s*g/m^3)/(g/m*s) = unitless
Re_process = D_impeller^2*N*row_mixture/mu_mixture;

% prandtl number (Pr) - (J/g*K)*(g/m*s)/(J/s*m*K)
Pr_process = Cp_mixture*mu_mixture/k_mixture;

% h_i calculation from Nusselt number (Nu) relationship - (J/s*m*K)/m = J/s*m^2*K
h_i = k_mixture*a*(Re_process^(2/3))*(Pr_process.^(1/3))*1^0.14/D_T;

end


