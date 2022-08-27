clear,clc

sulfonyl_chloride_conc = 1.7; % 1.7M sulfonyl chloride solution in diglyme (M or mol/L)
deltaH_rxn = -192000; % heat of reaction per mole of sulfonamide formation (J/mol)
Vol_NH4OH = 200;
Vol_diglyme = 0;
V = Vol_NH4OH + Vol_diglyme;
row_diglyme = 0.937; % density of diglyme (g/mL)
row_NH4OH_15N = 0.88; % density of 15N NH4OH (g/mL)
row_water = 1; % density of water (g/mL)
row_NH4OH_10N = row_water*1/3+row_NH4OH_15N*2/3; % density of 10N NH4OH(g/mL)
MW_diglyme = 134.18; % MW of diglyme (g/mol)
MW_NH4OH = 35.04; 
mol_NH4OH = Vol_NH4OH*row_NH4OH_10N/MW_NH4OH;
mol_diglyme = Vol_diglyme*row_diglyme/MW_diglyme;
mol_total = mol_NH4OH + mol_diglyme;
mol_fraction_NH4OH = mol_NH4OH/mol_total;
mol_fraction_diglyme = mol_diglyme/mol_total;
Cp_diglyme = 279.84; % heat capacity of diglyme (J/mol*K)
Cp_NH4OH = 34.807*4.184; % heat capacity of ammonium hydroxide at 270K unit conversion from 34.807 cal/mol*K (1 ca; = 4.184J) = (J/mol*K)
Cp_mixture = mol_fraction_diglyme*Cp_diglyme + mol_fraction_NH4OH*Cp_NH4OH; %(J/mol*K)
diglyme_flowrate = 1/60; % flow rate of diglyme (mL/s)
F_A = sulfonyl_chloride_conc/1000*diglyme_flowrate;
T_a = 273.15 - 5; % jacket temperature (K)
T = 273.15 - 5; % starting reaction mixture temperature (K)
t = 0.1;
X = 1; % conversion of sulfonyl chloride to sulfonamide, 100%
UA = 0.01*V + 2.6667;
Q_RJ = F_A*Cp_mixture*(T_a - T)*(1 - exp(-UA/(F_A*Cp_mixture)));
row_mixture_HTF = 1079.97/1000; % density of 50/50 EG/water at -5C (g/mL) from literature, unit conversion from kg/m^3
Q_HTF = 1*1000/60; % flow rate of heat transfer fluid converted from 1L/min to mL/s
mass_flowrate_HTF = Q_HTF*row_mixture_HTF; % mL/s * g/mL = g/s
Cp_HTF = 3.1689; % heat capcity of 50/50 water/ethylene glycol (J/g*K) from literature

%%
% every loop is 0.1 sec
for i=2:120000;
Vol_diglyme(i) = Vol_diglyme(i-1) + diglyme_flowrate*t; % (mL)
V(i) = Vol_diglyme (i) + Vol_NH4OH; %(mL)
mol_diglyme(i) = Vol_diglyme(i)*row_diglyme/MW_diglyme;
mol_total(i) = mol_NH4OH + mol_diglyme(i);
mol_fraction_NH4OH (i)= mol_NH4OH/mol_total(i);
mol_fraction_diglyme(i) = mol_diglyme(i)/mol_total(i);
Cp_mixture(i) = mol_fraction_diglyme(i)*Cp_diglyme + mol_fraction_NH4OH(i)*Cp_NH4OH; %(J/mol*K)
UA(i) = 0.01*V(i) + 2.6667;
%Q_RJ(i) = F_A*Cp_mixture(i)*(T_a - T(i-1))*(1 - exp(-UA(i)/(F_A*Cp_mixture(i))));

T = 278.15;
T_a = 273.15-5;
x = exp((-UA/(mass_flowrate_HTF*Cp_HTF)));
y = mass_flowrate_HTF*Cp_HTF*(T_a - T);
Q = y*(1-x);
Q_gen = F_A*X*(-deltaH_rxn);

Q_RJ(i) = mass_flowrate_HTF*Cp_HTF*(T_a - T(i-1))*(1 - exp((-UA(i)/(mass_flowrate_HTF*Cp_HTF))));
a(i) = Q_RJ(i);
b(i) = F_A*X*(-deltaH_rxn);
c(i) = F_A*Cp_mixture(i)*(T(i-1));
d(i) = V(i)*(mol_NH4OH/V(i)*Cp_NH4OH + mol_diglyme(i)/V(i)*Cp_diglyme);

T(i) = (Q_RJ(i) + F_A*X*(-deltaH_rxn) + F_A*Cp_mixture(i)*(T(i-1) - T_a))/(V(i)*(mol_NH4OH/V(i)*Cp_NH4OH + mol_diglyme(i)/V(i)*Cp_diglyme))*t;
end

plot(T)
% plot(Vol_diglyme)
plot(V)
% plot(mol_fraction_NH4OH)
% plot(mol_fraction_diglyme)
% plot(UA)
plot(Q_RJ)
% 
plot(a)
hold on
plot(b)
hold on
plot(c)

