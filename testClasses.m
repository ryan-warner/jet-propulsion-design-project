function testClasses

% Set up diffuser and initial conditions
testDiffuser = diffuser(0.92, 1.4,1.5);
testDiffuser = testDiffuser.temperatureChange(220);
testDiffuser = testDiffuser.pressureChange(10000);

% Fan Stage
testFan = fan(0.9, 1.2, 1.4, 245, 2);
testFan = testFan.temperatureChange(testDiffuser.temperatureFinal);
testFan = testFan.pressureChange(testDiffuser.pressureFinal);
testFan = testFan.workCalc();

% Compression Stage
testCompressor = compressor(30, 1.38, 0.9);
testCompressor = testCompressor.temperatureChange(testFan.temperatureFinal);
testCompressor = testCompressor.pressureChange(testFan.pressureFinal);
testCompressor = testCompressor.workCalc();

% Burner
testBurner = burner(0.98, 1.33, 0.99, 45000000, 0.018, 1300, 0.1);
testBurner = testBurner.temperatureChange(testCompressor.temperatureFinal);
testBurner = testBurner.pressureChange(testCompressor.pressureFinal);

% Turbine Stage - using 0.1 as b
testTurbine = turbine(0.92, 1.33, 1300, 0.1, 700, testCompressor.work, 0.018);
    % If we take 1689 as burner final all numbers work - either our final
    % temp is off or bro rounded weird...
testTurbine = testTurbine.temperatureChange(testBurner.temperatureFinal, testCompressor.temperatureInitial, testCompressor.temperatureFinal, testCompressor.specificHeat);
testTurbine = testTurbine.pressureChange(testBurner.pressureFinal);

% Bleed Air Mixer - using 0.1 as b
testMixer = bleedAirMixer(1.34, 0.1, 0.018);
testMixer = testMixer.temperatureChange(testTurbine.temperatureFinal, testCompressor.temperatureFinal);
testMixer = testMixer.pressureChange(testTurbine.pressureFinal, testCompressor.temperatureFinal);

% Fan Turbine
testFanTurbine = fanTurbine(0.92, 1.33, 0.018, 2, testFan.gamma);
testFanTurbine = testFanTurbine.temperatureChange(testMixer.temperatureFinal, testFan.temperatureInitial, testFan.temperatureFinal);
testFanTurbine = testFanTurbine.pressureChange(testMixer.pressureInitial);
testFanTurbine = testFanTurbine.workCalc();

% Afterburner Stage - Temperature Wrong!
testAfterburner = afterburner(1.32, 0.96, 0.018, 0.010, 2200, 45000000, 0.97);
testAfterburner = testAfterburner.temperatureChange(testFanTurbine.temperatureFinal);
testAfterburner = testAfterburner.pressureChange(testFanTurbine.pressureFinal);
testAfterburner = testAfterburner.maxFuelAirRatioCalc()

% Core Nozzle
testCoreNozzle = coreNozzle(0.95, 1.35, testAfterburner.pressureFinal, testDiffuser.pressureInitial);
testCoreNozzle = testCoreNozzle.temperatureChange(testAfterburner.temperatureFinal);
testCoreNozzle = testCoreNozzle.velocityCalc()

% Fan Nozzle
testFanNozzle = fanNozzle(0.97, 1.4, testDiffuser.pressureInitial);
testFanNozzle = testFanNozzle.temperatureChange(testFan.pressureFinal, testFan.temperatureFinal);
testFanNozzle = testFanNozzle.velocityCalc(testFan.temperatureFinal)

% Nozzle Mixer
testNozzleMixer = nozzleMixer(2, 0.018, 0.01, testAfterburner.temperatureFinal, testFan.temperatureFinal, 0.80);
testNozzleMixer = testNozzleMixer.temperatureChange();
testNozzleMixer = testNozzleMixer.gammaCalc();
testNozzleMixer = testNozzleMixer.pressureChange(testFan.pressureFinal, testAfterburner.pressureFinal);


% Combined Nozzle
testCombinedNozzle = combinedNozzle(.95, 1.37, 2, 0.018, 0.010, 45000000, 1.5, 10000);
testCombinedNozzle = testCombinedNozzle.temperatureChange(testNozzleMixer.temperatureFinal, testNozzleMixer.pressureFinal);
testCombinedNozzle = testCombinedNozzle.exitVelocityCalc(testNozzleMixer.pressureFinal);
testCombinedNozzle = testCombinedNozzle.thermalEfficiencyCalc();
testCombinedNozzle = testCombinedNozzle.dragLossCalc();
testCombinedNozzle = testCombinedNozzle.specificThrustCalc();
testCombinedNozzle = testCombinedNozzle.propulsiveEfficiencyCalc();
testCombinedNozzle = testCombinedNozzle.efficiencyCalc();
testCombinedNozzle = testCombinedNozzle.TSFCCalc();

%Separate Nozzle
testSeparateNozzle = separateNozzle(1.33, testCombinedNozzle.exitVelocity, 0.018, 0.010, 2, testCombinedNozzle.u, 45000000);
testSeparateNozzle = testSeparateNozzle.thermalEfficiencyCalc();
testSeparateNozzle = testSeparateNozzle.propulsiveEfficiencyCalc(testCombinedNozzle.effectiveSpecificThrust);
testSeparateNozzle = testSeparateNozzle.efficiencyCalc();
testSeparateNozzle = testSeparateNozzle.specificThrustCalc(testCombinedNozzle.specificDragLoss, testCoreNozzle.exitVelocity, testFanNozzle.exitVelocity);
testSeparateNozzle = testSeparateNozzle.TSFCCalc();
testSeparateNozzle = testSeparateNozzle.maxFuelAirRatioCalc();

% Fuel Pump
% effieiency 0.35
% initial 104 kpa
% outlet 550 kpa
% density 780
testFuelPump = fuelPump(780, 0.018, 0.35);
testFuelPump = testFuelPump.pumpWork(testBurner.pressureInitial, 104000)

% Ryan Testing

prettyPrint({testDiffuser, testFan, testCompressor, testBurner, testTurbine, testMixer, testFanTurbine, testAfterburner, testCoreNozzle, testFanNozzle, testNozzleMixer, testCombinedNozzle})

end