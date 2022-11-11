%% Jet and Rocket Propulsion Project F22

%Authors: Spencer Baird, Ryan Warner, Zack Dearman

%% Design Parameters

%Ambient Temp
Ta     =   220;         %K

%Ambient Pressure
pa     =   10;         %kPa

%Fuel Storage Pressure
p_f     =   0;         %kPa

%Flight Mach Number
M_inf   =   1.5;

%Core Air Mass Flow Rate Entering Compressor
ma      =   0;         %kg/s

%Fuel Mass Flow Rate for Main Burner
mf      =   0;         %kg/s

%Fuel Mass Flow Rate for Afterburner
mf_ab   =   0;         %kg/s

%Air Mass Flow Rate Bled from Compressor
mb      =   0;

%Air Mass Flow Rate of Secondary Air Bypassing Compressor
ms      =   0;

%Fuel:Air Ratio for Main Burner (mf / ma)
f       =   0.018;

%Fuel:Air Ratio for Afterburner (mf_ab / ma)
f_ab    =   0.01;

%Bypass Ratio (ms / ma)
B       =   2;

%Bleed Ratio (mb / ma)
b       =   0.1;

Mbar    =  0.0288;
R       =  8.3145 ./ Mbar;

%% Component & Flow Properties

%Average Specific Heat Ratio

%Gas Molecular Weight


%% DIFFUSER

%Diffuser Effeciency
nd      =   0.92;

%Diffuser Specific Heat
gamma_d =   1.4;

if M_inf < 1
    rd = 1;
else
    rd = 1 - 0.075 .* ((M_inf - 1) .^1.35);
end


%DIFFUSER OUTPUTS
T02 = Ta .* (1 + (0.5 .* (gamma_d - 1) .* (M_inf .^2)))
p02 = (pa .* ((1 + (nd .* ((T02 ./ Ta) - 1))) .^ (gamma_d ./ (gamma_d - 1)))) * rd;

%% FAN

%Fan Stagnation Pressure Ratio
pr_f    =   1.2;         %kPa

%Fan Polytropic Effeciency
nf_poly     =   0.90;

%Fan Specific Heat
gamma_f     =   1.4;

%C_beta_1
CB1         =   0.245; %kN*s / kg

%Fan Effeciency
nf = ((pr_f .^ ((gamma_f - 1) ./ gamma_f)) - 1) ./ ((pr_f .^ ((gamma_f - 1) ./ (gamma_f .* nf_poly))) - 1);



%FAN OUTPUTS
T03f = T02 .* (1 + (((pr_f .^ ((gamma_f - 1) ./ gamma_f)) - 1) ./ nf))
p03f = p02 .* pr_f



%% COMPRESSOR

%Compressor Stagnation Pressure Ratio
pr_c    =   30;         %kPa

%Compressor Polytropic Effeciency
nc_poly     =   0.90;

%Compressor Specific Heat
gamma_c     =   1.38;

%Compressor Effeciency
nc = ((pr_c .^ ((gamma_c - 1) ./ gamma_c)) - 1) ./ ((pr_c .^ ((gamma_c - 1) ./ (gamma_c * nc_poly))) - 1);



%COMPRESSOR OUTPUTS
T03 = T03f .* (1 + (((pr_c .^ ((gamma_c - 1) ./ gamma_c)) - 1) ./ nc))
p03 = p03f .* pr_c

%% MAIN BURNER

%Main Burner Effeciency
nb        =  0.99;

%Main Burner Specific Heat
gamma_b   =  1.33;

%Main Burner Stagnation Pressure Ratio
pr_b      =  0.98;

%Heat of Fuel
Q         =  45e6;




%% TURBINE






%% TURBINE MIXER




%% FAN TURBINE



%% AFTERBURNER



%% CORE NOZZLE


%% FAN NOZZLE



%% COMBINED NOZZLE
















%% 



