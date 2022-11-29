function testClasses

% Set up diffuser and initial conditions
testDiffuser = diffuser(0.92, 1.4,1.5);
testDiffuser = testDiffuser.temperatureChange(220);
testDiffuser = testDiffuser.pressureChange(10000)

% Fan Stage
testFan = fan(0.9, 1.2, 1.4, 245);
testFan = testFan.temperatureChange(testDiffuser.temperatureFinal);
testFan = testFan.pressureChange(testDiffuser.pressureFinal)

% Compression Stage
testCompressor = compressor(30, 1.38, 0.9, 0);
testCompressor = testCompressor.temperatureChange(testFan.temperatureFinal);
testCompressor = testCompressor.pressureChange(testFan.pressureFinal)

% Burner
testBurner = burner(0.98, 1.33, 0.99, 45000000, 0.018, 1300, 0.1);
testBurner = testBurner.temperatureChange(testCompressor.temperatureFinal);
testBurner = testBurner.pressureChange(testCompressor.pressureFinal)

% Turbine Stage - using 0.1 as b
testTurbine = turbine(0.92, 1.33, 1300, 0.1, 700, testCompressor.workrate, testCompressor.flowrate, 0.018);
    % If we take 1689 as burner final all numbers work - either our final
    % temp is off or bro rounded weird...
testTurbine = testTurbine.temperatureChange(testBurner.temperatureFinal, testCompressor.temperatureInitial, testCompressor.temperatureFinal, testCompressor.specificHeat);
testTurbine = testTurbine.pressureChange(testBurner.pressureFinal)

% Bleed Air Mixer - using 0.1 as b
testMixer = bleedAirMixer(1.34, 0.1, 0.018);
testMixer = testMixer.temperatureChange(testTurbine.temperatureFinal, testCompressor.temperatureFinal);
testMixer = testMixer.pressureChange(testTurbine.pressureFinal, testCompressor.temperatureFinal)

% Fan Turbine
testFanTurbine = fanTurbine(0.92, 1.33, 0.018, 2, testFan.gamma);
testFanTurbine = testFanTurbine.temperatureChange(testMixer.temperatureInitial, testFan.temperatureInitial, testFan.temperatureFinal);
testFanTurbine = testFanTurbine.pressureChange(testMixer.pressureInitial)

end