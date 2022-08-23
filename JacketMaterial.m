 function OutputJacketMaterial = JacketMaterial(H)

D_T = 8.8*0.01;
%D_ji = 11.2*0.01;
D_ji = 9.2*0.01;
k_MOC = 1.06; % thermal conductivitiy of glass (W/m*K) or (J/s*m*K)

% Heat transfer through jacket material m*J/s*m*K = J/s*K
JacketMaterialUA = (log(D_ji/2) - log(D_T/2))/(2*pi*H*k_MOC);
%JacketMaterialUA = log((D_ji/2)/(D_T/2))/(2*pi*H*k_MOC);

OutputJacketMaterial = JacketMaterialUA;

end

