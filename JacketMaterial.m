function OutputJacketMaterial = JacketMaterial(Vol_reaction)

D_T = 8.8*0.01;
D_ji = 11.2*0.01;
H = 7130.7*Vol_reaction + 2.8862; % height of reaction mixture (m)
k_MOC = 1.06; % thermal conductivitiy of glass (W/m*K)

% Heat transfer through jacket material
JacketMaterialUA = (log(D_ji/2) - log(D_T/2))/(2*pi*H*k_MOC);

OutputJacketMaterial = JacketMaterialUA;

end

