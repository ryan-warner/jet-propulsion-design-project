function generatePlots

turbojetGroundRoll = turbojet(100000, 285);
turbojetCruise = turbojet(29000, 220);

turbofanGroundRoll = turbofan(100000, 285);
turbofanCruise = turbofan(29000, 220);

close all;

compressionRatios = linspace(0, 100, 1000);
resultTurbofan = [];
resultTurbojet = [];

for i=1 : length(compressionRatios)
    resultTurbofan = [resultTurbofan,turbofanGroundRoll.engineCalc(0.018, 0.1, 0, 1.5, 2, compressionRatios(i), 0.01, 0.97, 1, 1).specificThrust / 1000];
    resultTurbojet = [resultTurbojet, turbojetGroundRoll.engineCalc(0.018, 0.2, 0, compressionRatios(i), 0.01, 1).specificThrust / 1000];
end
plt = plot(compressionRatios, resultTurbofan, compressionRatios, resultTurbojet)
ylabel("Specific Thrust kN*s/kg")
xlabel("Compressor Stagnation Pressure Ratio")
yticks([0:0.25:4])
legend("Turbofan", "Turbojet")

fuelAirRatios = linspace(0.01, 0.5, 1000);
resultTurbofan = [];
resultTurbojet = [];

for i=1 : length(fuelAirRatios)
    resultTurbofan = [resultTurbofan,turbofanGroundRoll.engineCalc(fuelAirRatios(i), 0.1, 0, 1.5, 2, 30, 0.01, 0.97, 1, 1).thrustSpecificFuelConsumption * 1000];
    resultTurbojet = [resultTurbojet, turbojetGroundRoll.engineCalc(fuelAirRatios(i), 0.2, 0, 30, 0.01, 1).thrustSpecificFuelConsumption * 1000];
end
figure("Name","TSFC")
plt = plot(fuelAirRatios, resultTurbofan, fuelAirRatios, resultTurbojet)
ylabel("Thrust Specific Fuel Consumption kg/kN*s")
xlabel("Fuel to Air Ratio")
legend("Turbofan", "Turbojet")

compressionRatios = linspace(0, 100, 1000);
resultTurbofanCombo = [];
resultTurbofanSeparate = [];

for i=1 : length(fuelAirRatios)
    resultTurbofanCombo = [resultTurbofanCombo,turbofanGroundRoll.engineCalc(0.018, 0.1, 0, 1.5, 2, compressionRatios(i), 0.01, 0.97, 1, 1).specificThrust / 1000];
    resultTurbofanSeparate = [resultTurbofanSeparate, turbofanGroundRoll.engineCalc(0.018, 0.1, 0, 1.5, 2, compressionRatios(i), 0.01, 0.97, 1, 1).separateNozzle.ST / 1000];
end

figure("Name","ST")
plt = plot(compressionRatios, resultTurbofanCombo, compressionRatios, resultTurbofanSeparate)
ylabel("Specific Thrust kN*s/kg")
xlabel("Compressor Stagnation Pressure Ratio")
legend("Turbofan - Combined Nozzle", "Turbofan - Separate Nozzle")

bypassRatios = linspace(0, 20, 1000);
resultTurbofanGround = [];
resultTurbofanCruise = [];

for i=1 : length(bypassRatios)
    resultTurbofanGround = [resultTurbofanGround,turbofanGroundRoll.engineCalc(0.018, 0.1, 0, 1.5, bypassRatios(i), 30, 0.01, 0.97, 1, 1).specificThrust / 1000];
    resultTurbofanCruise = [resultTurbofanCruise, turbofanCruise.engineCalc(0.018, 0.1, 0.86, 1.5, bypassRatios(i), 30, 0.01, 0.97, 1, 1).specificThrust / 1000];
end

figure("Name","Bypass") 
plt = plot(bypassRatios, resultTurbofanGround, bypassRatios, resultTurbofanCruise)
ylabel("Specific Thrust kN*s/kg")
xlabel("Bypass Ratio")
legend("Turbofan - Ground", "Turbofan - Cruise")

end