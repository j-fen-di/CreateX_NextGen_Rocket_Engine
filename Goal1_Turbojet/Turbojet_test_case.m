% Turbojet equations for flight condition: low altitude subsonic cruise
% Requirements:
% ST > 380 N * s / kg
% TSFC minimized
% T_max_burner = 1300 K
% T_max_afterburner = 2200 K

% Given values
T_a = 220; %K
P_a = 10000; %Pa
M = 1.50;

gamma_a = 1.4;
gamma_2 = 1.4;
gamma_3 = 1.38;
gamma_4 = 1.33;
gamma_5 = 1.33;
gamma_6 = 1.32;
gamma_e = 1.35;
eta_d = 0.92;
eta_b = 0.99;
eta_pc = 0.9; % Polytropic
eta_pt = 0.92; % Polytropic
eta_ab = 0.96;
eta_n = 0.95;
Pr_b = 0.98;
Pr_ab = 0.97;
deltahr = 45E6; % J / kg
RR = 8.314; % J / mol * K
MolMass = .0288; % kg / mol
R = RR ./ MolMass;

% Design Parameters
Pr_c = 30;
f = 0.018;
f_ab = 0.01;

% Flight speed, station a
u = M .* sqrt(gamma_a .* R .* T_a);

% Diffuser outlet, station 2
if (M < 1)
    r_d = 1;
else
    r_d = 1 - 0.075 .* (M - 1) .^ 1.35;
end
T_o2 = T_a .* (1 + ((gamma_2 - 1) ./ 2) .* M .^ 2);
P_o2 = P_a .* r_d .* (1 + eta_d .* ((gamma_2 - 1) ./ 2) .* M .^ 2) .^ (gamma_2 ./ (gamma_2 - 1));

% Compressor outlet, station 3
C_p3 = (gamma_3 .* R) ./ (gamma_3 - 1);
T_o3 = T_o2 .* Pr_c .^ (R ./ (C_p3 .* eta_pc));
P_o3 = Pr_c .* P_o2;

% Burner outlet, station 4
P_o4 = P_o3 .* Pr_b;
C_p4 = (gamma_4 .* R) ./ (gamma_4 - 1);
T_o4 =  (((f .* eta_b .* deltahr) ./ (C_p4 .* T_o3)) + 1) ./ ((f + 1) ./ T_o3);

% Turbine outlet, station 5
C_p5 = (gamma_5 .* R) ./ (gamma_5 - 1);
T_o5 = T_o4 - ((C_p3 .* (T_o3 - T_o2)) ./ ((1 + f) .* C_p5));
P_o5 = P_o4 .* (T_o5 ./ T_o4) .^ (C_p5 ./ (R .* eta_pt));

% Afterburner outlet, station 6
C_p6 = (gamma_6 .* R) ./ (gamma_6 - 1);
T_o6 = ((1 + f) .* T_o5 + ((eta_ab .* f .* deltahr) ./ C_p6)) ./ (1 + f + f_ab);
P_o6 = Pr_ab .* P_o5;

% Nozzle exit, station e
P_e = P_a;
T_e = T_o6 .* (1 - eta_n .* (1 - (P_e ./ P_o6) .^ ((gamma_e - 1) ./ gamma_e)));
C_pe = (gamma_e .* R) ./ (gamma_e - 1);
u_e = sqrt(2 .* C_pe .* (T_o6 - T_e));
ST = (1 + f + f_ab) .* u_e - u;
TSFC = (f + f_ab) ./ ST;
eta_th = (((1 + f + f_ab) .* (u_e .^ 2)) - (u .^ 2)) ./ ((f + f_ab) .* deltahr);
eta_o = u ./ (TSFC .* deltahr);
eta_p = eta_o ./ eta_th;