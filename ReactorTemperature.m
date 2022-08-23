

D_T = 8.8*0.01; % internal diameter of tank (m)
D_ji = 11.2*0.01; % inner diameter of jacket (m)
density_diglyme = 0.937; % diglyme density (g/mL)
MW_diglyme = 134.18; % MW of diglyme (g/mol)
density_NH4OH = 0.920; % density of 10N NH4OH (g/mL)
MW_NH4OH = 36.04; % MW of NH4OH (g/mol)
T_a = 273.15-5; % jacket temperature (K)
T_o = 273.15+25; % inlet flow stream temperature (K)
deltaH_rxn = 192000; % heat of reaction per mole of sulfonamide formation (J/mol)
MW_sulfonamide = 289.15; % MW of sulfonamide (g/mol)
diglyme_conc = 1.7; % concentration of sulfonyl chloride in diglyme (M)
Vol_diglyme = 0;

T = -5 + 273.15; % starting process temperature (K)

% each loop is 1 sec

%for i = 1:9000
for i = 1:12000
           
    diglyme_flowrate = 1/60; % flow rate of diglyme (mL/s)
    
    Vol_NH4OH = 200; % diglyme solution volume (mL)
    Vol_diglyme = Vol_diglyme + diglyme_flowrate*1; % NH4OH solution volume (mL) - addition of NH4OH every 1 sec (Vol_reaction + flowrate*1sec)
    Vol_reaction(i) = Vol_diglyme + Vol_NH4OH;
    
    Vol_reaction_500rpm = 1.125*Vol_reaction(i)+100;
    
    H(i) = 0.0001*Vol_reaction_500rpm + 0.0003; % height of reaction mixture (m)
    
    A_i(i) = pi*D_T*H(i);
    A_o(i) = pi*D_ji*H(i);
    
    fraction_diglyme = Vol_diglyme/Vol_reaction(i);
    fraction_NH4OH = Vol_NH4OH/Vol_reaction(i);
    
    mole_fraction_diglyme = (Vol_diglyme*density_diglyme/MW_diglyme)/(Vol_diglyme*density_diglyme/MW_diglyme + Vol_NH4OH*density_NH4OH/MW_NH4OH);
    mole_fraction_NH4OH = (Vol_NH4OH*density_NH4OH/MW_NH4OH)/(Vol_diglyme*density_diglyme/MW_diglyme + Vol_NH4OH*density_NH4OH/MW_NH4OH);
        
    MolVol_diglyme = Vol_reaction(i)/(Vol_diglyme*density_diglyme/MW_diglyme);
    MolVol_NH4OH = Vol_reaction(i)/(Vol_NH4OH*density_NH4OH/MW_NH4OH);
    
    h_i(i) = Process(T(i), fraction_diglyme, fraction_NH4OH, MolVol_diglyme, MolVol_NH4OH); %J/s*m^2*K
    h_o(i) = Jacket(H(i)); % J/s*m^2*K
    OutputJacketMaterial(i) = JacketMaterial(H(i)); % J/s*K

    %UA(i) = 1/(1/(h_i(i)*A_i(i)) + 1/(h_o(i)*A_o(i)) + OutputJacketMaterial(i));
    inv_UA(i) = 1/(h_i(i)*A_i(i)) + 1/(h_o(i)*A_o(i)) + OutputJacketMaterial(i);
    UA(i) = 1/inv_UA(i);
    
    Cp_diglyme = 2.09; % heat capacity of diglyme (J/g*K) or 279.84 J/mol*K
    Cp_NH4OH = 34.807*4.184/35.04; % heat capacity of ammonium hydroxide at 270K unit conversion from cal/mol*K (J/g*K)
    Cp_mixture = fraction_diglyme*Cp_diglyme + fraction_NH4OH*Cp_NH4OH; %(J/g*K)
    
    F_Ao = diglyme_flowrate*density_diglyme;
           
    T (i+1)= ((UA/F_Ao)*T_a + Cp_mixture*T_o - deltaH_rxn/MW_sulfonamide*diglyme_flowrate*diglyme_conc/1000)/(UA/F_Ao - Cp_mixture);
    
    
    h_i_A_i(i) = h_i(i)*A_i(i);
    h_o_A_o(i) = h_o(i)*A_o(i);
    
    invh_i_A_i(i) = 1/h_i_A_i(i);
    invh_o_A_o(i) = 1/h_o_A_o(i);

            
end


    plot(T)
    plot(UA)
    
    plot(h_o_A_o)
    
    
    plot(invh_i_A_i)
    hold on
    plot(invh_o_A_o)
    
    plot(h_i)
    hold on
    plot(h_o)
    
    plot(A_i)
    hold on
    plot(A_o)
    hold on
    plot(A_o)
    plot(OutputJacketMaterial)
    plot(H)
    plot(Vol_reaction)
    
