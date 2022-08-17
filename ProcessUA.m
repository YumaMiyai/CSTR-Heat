function OutputProcessUA = ProcessUA(x, y, z)

D_impeller = 6.7*0.01; % diameter of impeller (m)
N = 300/60*2*3.14; % impeller speed in rps (unit conversion from 300 rpm)
row_diglyme = 937; % density of diglyme (kg/m^3)
row_NH4OH_15N = 880; % density of 15N NH4OH (kg/m^3)
row_water = 1000; % density of water (kg/m^3)
row_NH4OH_10N = row_water*1/3+row_NH4OH_15N*2/3; % density of 10N NH4OH(kg/m^3)
row_mixture = fraction_diglyme*row_diglyme + fraction_NH4OH*row_NH4OH_10N; % density of reaction mixture(kg/m^3)
mu_diglyme = (0.0002*T_diglyme^2 - 0.1408*T_diglyme + 24.591)/1000*1000; % viscosity calculation from -5 to 60C converting from mPa*s to Pa*s to kg/m*s to g/m*s
mu_NH4OH_26 = (0.0014*T_NH4OH^2 - 0.0658*T_NH4OH + 2.0518)/1000*1000; % viscosity calculation from -10 to 25C converting from mPa*s to Pa*s to kg/m*s to g/m*s
mu_mixture = exp(fraction_diglyme*log(mu_diglyme) + fraction_NH4OH_26*log(mu_NH4OH_26));
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
D_T = 8.8*0.01; % internal diameter of tank (in m)
a = 0.74; % flat blade turbine

% Reynolds number (Re)
Re_process = D_impeller^2*N*row_mixture/mu_mixture;

% prandtl number (Pr)
Pr_process = Cp_mixture*mu_mixture/k_mixture;

% h_i calculation from Nusselt number (Nu) relationship
h_i = k_mixture*a*(Re_process^(2/3))*(Pr_process^(1/3))*1^0.14/D_T;

OutputProcessUA = h_i;

end


