% Turbojet equations for flight condition: low altitude subsonic cruise
% Requirements:
% ST > 380 N * s / kg
% TSFC minimized
% T_max_burner = 1300 K
% T_max_afterburner = 2200 K

% Given values
T_a = 220; %K
P_a = 10000; %Pa
M = 1.5;

gamma_a = 1.4;
gamma_2 = 1.4;
gamma_3f = 1.4;
gamma_3 = 1.38;
gamma_4 = 1.33;
gamma_51 = 1.33;
gamma_5m = 1.34;
gamma_52 = 1.33;
gamma_6 = 1.32;
gamma_e = 1.35;
gamma_ef = 1.4;
gamma_ec = 1.37;
eta_d = 0.92;
eta_pf = 0.9; % Polytropic
eta_b = 0.99;
eta_pc = 0.9; % Polytropic
eta_pump = 0.35;
eta_pt = 0.92; % Polytropic
eta_ft = 0.92; % Polytropic
eta_ab = 0.96;
eta_n = 0.95;
eta_fn = 0.97;
eta_cn = 0.95;
b_max = 0.12;
C_b1 = 700; % K
Pr_b = 0.98;
Pr_ab = 0.97;
Pr_nm = 0.8;
T_max0 = 1300; % K
T_maxab = 2200; % K
deltahr = 45E6; % J / kg
rho_f = 780;
P_f1 = 104E3; % Pa
deltap_inj = 550E3; % Pa
RR = 8.314; % J / mol * K
MolMass = .0288; % kg / mol
R = RR ./ MolMass;

% Design Parameters
Pr_f = 1.2;
Pr_c = 30;
f = 0.018;
f_ab = 0.01;
b = 0.1;
beta = 2;

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

% Fan outlet, station 3f
C_p3f = (gamma_3f .* R) ./ (gamma_3f - 1);
T_o3f = T_o2 .* (Pr_f) .^ (R ./ (C_p3f .* eta_pf));
P_o3f = Pr_f .* P_o2;
w_f = (1 + beta) .* C_p3f .* (T_o3f - T_o2);

% Compressor outlet, station 3
C_p3 = (gamma_3 .* R) ./ (gamma_3 - 1);
T_o3 = T_o3f .* Pr_c .^ (R ./ (C_p3 .* eta_pc));
P_o3 = Pr_c .* P_o3f;
w_c = C_p3 .* (T_o3 - T_o3f);

% Burner outlet, station 4
P_o4 = P_o3 .* Pr_b;
C_p4 = (gamma_4 .* R) ./ (gamma_4 - 1);
T_o4 =  (((f .* eta_b .* deltahr) ./ C_p4) + ((1 - b) .* T_o3)) ./ (1 - b + f);
T_max = T_max0 + C_b1 .* (b ./ b_max) .^ (1 ./ 2);
f_max = ((1 - b) .* (T_o3 - T_max)) ./ (T_max - ((eta_b .* deltahr) ./ C_p4));

% Fuel pump
P_f2 = deltap_inj + P_o3;
w_p = ((f + f_ab) .* (P_f2 - P_f1)) ./ (eta_pump .* rho_f);

% Turbine outlet, station 51
C_p51 = (gamma_51 .* R) ./ (gamma_51 - 1);
T_o51 = T_o4 - (w_c + w_p) ./ ((1 - b + f) .* C_p51);
P_o51 = P_o4 .* (T_o51 ./ T_o4) .^ (C_p51 ./ (R .* eta_pt));

% Turbine mixer, station 5m
C_p5m = (gamma_5m .* R) ./ (gamma_5m - 1);
T_o5m = ((1 - b + f) .* T_o51 + b .* T_o3) ./ (1 + f);
% temp1 = (b .* C_p5m .* log(T_o51./T_o3)) ./ (R .* (1 + f));
% temp2 = (C_p5m .* log(T_o5m./T_o51)) ./ R;
% P_o5m = P_o51 .* exp(temp1 - temp2);
P_o5m = P_o51 .* ((P_o3 ./ P_o51) .^ (b ./ (1 + f))) .* ((T_o51 ./ T_o3) .^ ...
    ((b .* gamma_5m) ./ ((1 + f) .* (gamma_5m - 1)))) .* ((T_o5m ./ T_o51) .^ ...
    (gamma_5m ./ (gamma_5m - 1)));
% P_o5m = P_o51 .* (T_o5m ./ T_o51) .^ (gamma_5m ./ (gamma_5m - 1));
P_o5m = 163.6E6;

% Fan turbine, station 52
C_p52 = (gamma_52 .* R) ./ (gamma_52 - 1);
T_o52 = T_o5m - w_f ./ ((1 + f) .* C_p52);
P_o52 = P_o5m .* (T_o52 ./ T_o5m) .^ (C_p52 ./ (R .* eta_ft));

% Afterburner outlet, station 6
C_p6 = (gamma_6 .* R) ./ (gamma_6 - 1);
% T_o6 = ((1 + f + f_ab) .* T_o52 + ((eta_ab .* f .* deltahr) ./ C_p6)) ./ (1 + f + f_ab);
T_o6 = ((1 + f) ./ (1 + f + f_ab)) .* T_o52 + ((eta_ab .* deltahr .* f_ab) ./ C_p6);
P_o6 = Pr_ab .* P_o52;
f_maxab = ((1 + f) .* (T_o52 - T_maxab)) ./ (1 + f);

% Core nozzle exit, station e
P_e = P_a;
T_e = T_o6 .* (1 - eta_n .* (1 - (P_e ./ P_o6) .^ ((gamma_e - 1) ./ gamma_e)));
C_pe = (gamma_e .* R) ./ (gamma_e - 1);
u_e = sqrt(2 .* C_pe .* (T_o6 - T_e));

% Fan nozzle exit, station ef
C_pef = (gamma_ef .* R) ./ (gamma_ef - 1);
T_ef = T_o3f .* (1 - eta_fn .* (1 - ((P_e ./ P_o3f) .^ (R ./ C_pef))));
u_ef = sqrt(2 .* C_pef .* (T_o3f - T_ef));

% Nozzle mixer exit, station 7
T_o7 = (((1 + f + f_ab) .* (T_o6 - T_o3f)) ./ (1 + f + f_ab)) + T_o3f;
gamma_7 = 1.44 - (1.39E-4 .* T_o7) + (3.57E-8 .* (T_o7 .^ 2));
exp1 = (1 + f + f_ab) ./ (1 + beta + f + f_ab);
exp2 = gamma_7 ./ (gamma_7 - 1);
P_o7s = P_o3f .* (((T_o7 ./ T_o3f) .* (T_o3f ./ T_o6) .^ exp1) .^ exp2) .* ...
    ((P_o6 ./ P_o3f) .^ exp1);
P_o7 = P_o7s .* Pr_nm;

% Combined nozzle, station ec
C_pec = (gamma_ec .* R) ./ (gamma_ec - 1);
T_ec = T_o7 .* (1 - eta_cn .* (1 - ((P_a ./ P_o7) .^ (R ./ C_pec))));
u_ec = sqrt(2 .* C_pec .* (T_o7 - T_ec));

% ST = (1 + f + f_ab) .* u_e - u;
% TSFC = (f + f_ab) ./ ST;
% eta_th = (((1 + f + f_ab) .* (u_e .^ 2)) - (u .^ 2)) ./ ((f + f_ab) .* deltahr);
% eta_o = u ./ (TSFC .* deltahr);
% eta_p = eta_o ./ eta_th;