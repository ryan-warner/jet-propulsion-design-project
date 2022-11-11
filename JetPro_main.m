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
CB1_f       =   0.245; %kN*s / kg

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
Q_b       =  45e6;

%Cp
Cp = R .* (gamma_b ./ (gamma_b - 1));

p04 = p03 .* pr_b
T04 = 10 .^3 .* (1 + (f .* nb .* Q_b) ./ (Cp * T03)) ./ (1 + f)


%% TURBINE

%Turbine Polytropic Efficiency
nt_poly   =  0.92;

%Turbine Specific Heat
gamma_t   =  1.33;

%Turbine Max Temperature
T_max0_t  =  1300;   %K

%Turbine Max Bleed Ratio
b_max_t   =  0.12;

%Turbine C_beta1
C_b1_t    =  700;    %K

%Turbine Stagnation Temperature Ratio
T_r_t     =  0.0;

%Turbine Efficiency
nt = (T_r_t - 1) ./ (T_r_t .^(1/nt_poly) - 1);


%% TURBINE MIXER

%Turbine Mixer Specific Heat
gamma_tm  =  1.34;



%% FAN TURBINE

%Fan Turbine Efficiency
nft_poly  =  0.92;

%Fan Turbine Specific Heat
gamma_ft  =  1.33;



%% AFTERBURNER

%Afterburner Efficiency
nab       =  0.96;

%Afterburner Stagnation Pressure Ratio
pr_ab     =  0.97;   %If used
%pr_ab     =  1.0;   %If not used

%Afterburner Specific Heat
gamma_ab  =  1.32;

%Uses same heating value as main

%Afterburner Max Temp
T_max_ab  =  2200;   %K (3780 R)



%% CORE NOZZLE

%Core Nozzle Efficiency
nn        =  0.95;

%Core Nozzle Specific Heat
gamma_n   =  1.35;



%% FAN NOZZLE

%Fan Nozzle Efficiency
nfn       =  0.97;   %If used

%Fan Nozzle Specific Heat
gamma_fn  =  1.4;



%% NOZZLE MIXER

%Nozzle Mixer Specific Heat
T07       =  1.0;   %Test for Zack, not actual value
gamma_nm  =  1.44 - (1.39e-4 .* T07) + (3.57e-8 .* (T07.^2));  %T in K

%Nozzle Mixer Stagnation Pressure Ratio
pr_nm     =  0.80;



%% COMBINED NOZZLE

%Combined Nozzle Efficiency
ncn       =  0.95;

%Combined Nozzle Specific Heat
gamma_cn  =  1.37;



%% FUEL PUMP

%Fuel Pump Efficiency
np        =  0.35;

rho_f_np  =  780;   %kg/m^3

p_f1_np   =  104;   %kPa

delta_p_inj_np  =  550;   %kPa


