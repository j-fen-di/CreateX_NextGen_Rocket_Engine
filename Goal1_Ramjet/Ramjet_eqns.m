% Ramjet equations for flight condition: high altitude supersonic cruise
% Requirements:
% ST > 750 N * s / kg
% TSFC minimized
% T_max = 1300 K

% Given values
T_a = 210; %K
P_a = 10000; %Pa
M = 2.6;

gamma_a = 1.4;
gamma_2 = 1.4;
gamma_4 = 1.33;
gamma_e = 1.35;
eta_d = 0.92;
eta_b = 0.99;
eta_n = 0.95;
Pr_b = 0.98;
deltahr = 45E6; % J / kg
R = 8.314; % J / mol * K
MolMass = .0288; % kg / mol

% Design parameters
% f = 0.0137; % Selected value
f = linspace(0.01, 0.1); % For optimization/plotting

% Flight speed, station a
u = M .* sqrt(gamma_a .* (R ./ MolMass) .* T_a);

% Diffuser outlet, station 2
if (M < 1)
    r_d = 1;
else
    r_d = 1 - 0.075 .* (M - 1) .^ 1.35;
end
T_o2 = T_a .* (1 + ((gamma_2 - 1) ./ 2) .* M .^ 2);
P_o2 = P_a .* r_d .* (1 + eta_d .* ((gamma_2 - 1) ./ 2 .* M .^ 2)).^ (gamma_2 ./ (gamma_2 - 1));

% Burner outlet, station 4
P_o4 = P_o2 .* Pr_b;
C_p4 = (R ./ MolMass) ./ (gamma_4 - 1);
T_o4 =  (((f .* eta_b .* deltahr) ./ (C_p4 .* T_o2)) + 1) ./ ((f + 1) ./ T_o2);

% Nozzle exit, station e
P_e = P_a;
T_e = T_o4 .* (1 - eta_n .* (1 - (P_e ./ P_o4) .^ ((gamma_e - 1) ./ gamma_e)));
C_pe = ((R ./ MolMass)) ./ (gamma_e - 1);
u_e = sqrt(2 .* C_pe .* (T_o4 - T_e));
ST = (1 + f) .* u_e - u;
TSFC = f ./ ST;
eta_p = (2 .* ST) ./ (u .* ((1 + f) .* (u_e ./ u) .^ 2 - 1));
eta_o = u ./ (TSFC .* deltahr);
eta_th = eta_o ./ eta_p;