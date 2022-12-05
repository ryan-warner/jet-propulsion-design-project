function goalOneOpt(engine, flightMach, reqSpecificThrust, x0)
% Minimize TSFC at the given ST

% x is of the form [fuelAirRatio, bleedRatio, flightMach, compressorStagnationPressureRatio, fuelAirRatioAfterburner, stagnationPressureRatioAfterburner]

%x0=[0.01, 0, flightMach, 2, 0, 2, reqSpecificThrust]; % Optimizer starting point
A=[0, 0, 1, 0, 0, 0, 1]; % matrix for linear inequality constraint for max AR
b=[flightMach + reqSpecificThrust];

Aeq=[0, 0, 1, 0, 0, 0, 1];
beq=[0; 0; 1; 0; 0; 0; 1];

lb=[0; 0; flightMach; 0; 0; 0; reqSpecificThrust]; % Lower bounds. Mostly 0?
ub=[100; 100; flightMach; 1000; 1000; 1000; reqSpecificThrust * 1.2]; % Upper bounds. Set by element?.

fun=@(x)engine.turbojetWrapper(x);

nonLinearInstance = nonLinearThrustConstraint(engine, x0(7));

nonlincon=@(x)nonLinearInstance.nonLinearFunc(x);

options=optimoptions(@fmincon,'Display','iter','Algorithm','interior-point', 'display','none', MaxFunctionEvaluations=300000, MaxIterations=10000);
[x,fVal, exitFlag] = fmincon(fun,x0,A,b,[],[],lb,ub,nonlincon,options)

end