% Ramjet optimization for flight condition: high altitude supersonic cruise
% Requirements:
% ST > 750 N * s / kg
% TSFC minimized
% T_max = 1300 K

% Since there's only one parameter to tune (f), I'll optimize by
% plotting the design requirements (ST, TSFC, T_max = T_o4)

figure(1)
hold on
yyaxis left
plot(f, ST)
plot([0.01, 0.1], [750, 750])
ylabel('Specific Thrust (N*s/kg)')
yyaxis right
plot(f, T_o4)
plot([0.1, 0.01], [1300, 1300])
title('Specific Thrust, Max Temperature vs Fuel to Air Ratio')
xlabel('Fuel to Air Ratio')
ylabel('Maximum Temperature (K)')
legend('Specific Thrust', '', 'Max Temperature', '')
saveas(gcf, 'Ramjet_ST_Tmax.png')

hold off
figure(2)
plot(f, TSFC)
title('Thrust Specific Fuel Consumption vs Fuel to Air Ratio')
xlabel('Fuel to Air Ratio')
ylabel('Thrust Specific Fuel Consumption')
saveas(gcf, 'Ramjet_TSFC.png')

% SELECTED VALUE: 0.0137