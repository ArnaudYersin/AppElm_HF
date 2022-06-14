clc
clear
close all
%%
antenna_name = "AppElm_antenne_dipole_FR4";
Sparam_base = sparameters(strcat('_base/',antenna_name, '_correct.s1p'));
[Fres_base, Smin_base] = find_F_res(Sparam_base, 1e9, 3e9);
Sparam_complex = squeeze(Sparam_base.Parameters);
Sparam_log = 20*log10(abs(Sparam_complex));
F_BW = find(Sparam_log < -10);
BW_base = Sparam_base.Frequencies(max(F_BW)) - Sparam_base.Frequencies(min(F_BW));

%% parameter sweep
save = false;
var_name = 'ls';

if strcmp(var_name,'i')
    var_base = 0.8;
elseif strcmp(var_name,'l1')
    var_base = 4;
elseif strcmp(var_name,'L')
    var_base = 38.8;
elseif strcmp(var_name,'ws')
    var_base = 80;
elseif strcmp(var_name,'ls')
    var_base = 30;
else
    return
end

var_min = 0.75*var_base;
var_max = 1.25*var_base;
var = linspace(var_min,var_max,11);

dSmin = zeros(1,length(var));
dBW = zeros(1,length(var));
dvar = zeros(1,length(var));
dF = zeros(1,length(var));
dF_dvar = zeros(1,length(var));
f1 = figure(1);
f1.Position = [0 100 600 500];
for index = 1:length(var)
    Sparam(index) = sparameters(strcat(var_name, '_param/', antenna_name, '_', num2str(index),'.s1p'));
    Sparam_complex = squeeze(Sparam(index).Parameters);
    Sparam_log = 20*log10(abs(Sparam_complex));
    % F résonnance
    [Fres, Smin] = find_F_res(Sparam(index), 1e9, 3e9);
    dvar(index) = var(index) - var_base;
    dF(index) = Fres - Fres_base;
    % Smin
    dSmin(index) = Smin - Smin_base;
    % Bande passante
    F_BW = find(Sparam_log < -10);
    if isempty(F_BW)
        BW = 0;
    else
        BW = Sparam(index).Frequencies(max(F_BW)) - Sparam(index).Frequencies(min(F_BW));
    end
    dBW(index) = BW - BW_base;
    % figure
    plot(Sparam(index).Frequencies,Sparam_log)
    hold on
    str_legend{index} = strcat(var_name,' = ',num2str(var(index)));
end
title(strcat('S11, ',var_name,' parameter sweep'))
legend(str_legend,'Location','southwest')
xlabel(strcat('Frequency [Hz]'))
ylabel(strcat('S11 [dB]'))
grid

%% Fréquence de résonnance
x_data = dvar/var_base*100;
y_data = dF/Fres_base*100;
f2 = figure(2);
f2.Position = [500 100 600 500];
plot(x_data,y_data,'-o')
title(strcat('\Delta','F / \Delta', var_name))
xlabel(strcat('\Delta', var_name, ' [%]'))
ylabel(strcat('\Delta', 'F_{rés}', ' [%]'))
xlim([min(x_data),max(x_data)])
grid

Fres_5 = [y_data(5), y_data(7)]
Fres_10 = [y_data(4), y_data(8)]
Fres_25 = [y_data(1), y_data(11)]
%% Minimum S11
x_data = dvar/var_base*100;
y_data = dSmin/Smin_base*100;
f3 = figure(3);
f3.Position = [1000 100 600 500];
plot(x_data,y_data,'-o')
title(strcat('\Delta','S11(F_{rés}) / \Delta', var_name))
xlabel(strcat('\Delta', var_name, ' [%]'))
ylabel(strcat('\Delta', 'S11(F_{rés})', ' [%]'))
xlim([min(x_data),max(x_data)])
grid

S11min_5 = [y_data(5), y_data(7)]
S11min_10 = [y_data(4), y_data(8)]
S11min_25 = [y_data(1), y_data(11)]
%% Bande passante
x_data = dvar/var_base*100;
y_data = dBW/BW_base*100;
f4 = figure(4);
f4.Position = [1500 100 600 500];
plot(x_data,y_data,'-o')
title(strcat('\Delta','BP / \Delta', var_name))
xlabel(strcat('\Delta', var_name, ' [%]'))
ylabel(strcat('\Delta', ' Bande Passante', ' [%]'))
xlim([min(x_data),max(x_data)])
grid

BW_5 = [y_data(5), y_data(7)]
BW_10 = [y_data(4), y_data(8)]
BW_25 = [y_data(1), y_data(11)]
%% Save
if save
    saveas(f1,strcat(var_name,'_param/result/',antenna_name,'_S11_',var_name,'_param.fig'))
    saveas(f1,strcat(var_name,'_param/result/',antenna_name,'_S11_',var_name,'_param.eps'),'epsc')
    saveas(f2,strcat(var_name,'_param/result/',antenna_name,'_Fres_',var_name,'_param.fig'))
    saveas(f2,strcat(var_name,'_param/result/',antenna_name,'_Fres_',var_name,'_param.eps'),'epsc')
    saveas(f3,strcat(var_name,'_param/result/',antenna_name,'_MinS11_',var_name,'_param.fig'))
    saveas(f3,strcat(var_name,'_param/result/',antenna_name,'_MinS11_',var_name,'_param.eps'),'epsc')
    saveas(f4,strcat(var_name,'_param/result/',antenna_name,'_BP_',var_name,'_param.fig'))
    saveas(f4,strcat(var_name,'_param/result/',antenna_name,'_BP_',var_name,'_param.eps'),'epsc')
end