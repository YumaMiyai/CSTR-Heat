

D_T = 8.8*0.01; % internal diameter of tank (m)
D_ji = 11.2*0.01; % inner diameter of jacket (m)

% each loop is 1 sec

for i = 1:100
    
    T = -5 + 273.15; % starting process temperature (K)
    
    Vol_diglyme = 150; % diglyme solution volume (mL)
    Vol_NH4OH = Vol_NH4OH + flowrate*1; % NH4OH solution volume (mL) - addition of NH4OH every 1 sec (Vol_reaction + flowrate*1sec)
    Vol_reaction = Vol_diglyme + Vol_NH4OH;
    
    H = 7130.7*Vol_reaction + 2.8862; % height of reaction mixture (m)
    
    A_i = pi*D_T*H;
    A_o = pi*D_ji*H;
    
    fraction_diglyme = Vol_diglyme/Vol_reaction;
    fraction_NH4OH = Vol_NH4OH/Vol_reaction;
        
    MolVol_diglyme = 
    MolVol_NH4OH = 
    
    h_i = ProcessUA(T, fraction_diglyme, fraction_NH4OH, MolVol_diglyme, MolVol_NH4OH);
    h_o = JacketUA(H);
    OutputJacketMaterial = JacketMaterialUA(H);

    UA = 1/(1/(h_i*A_i) + 1/(h_o*A_o) + OutputJacketMaterial); 
        
end
