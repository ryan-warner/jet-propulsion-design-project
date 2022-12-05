function goalOneBruteForce

% linspace all design parameters?
% Who knows

compressionRatios = linspace(0, 100, 100);
bleedRatios = linspace(0, 2, 20);
afterburnerCompressionRatios = [1, 0.97];
fuelAirRatios = linspace(0, 1, 50);
afterburnerFuelAirRatios = linspace(0, 1, 50);

turbojetGroundRoll = turbojet(100000, 285);
groundRollResult = [];
turbojetCruise = turbojet(29000, 220);
cruiseResult = [];

for i=1 : length(compressionRatios)
    for j=1 : length(bleedRatios)
        for k=1 : length(afterburnerFuelAirRatios)
            for u=1 : length(afterburnerCompressionRatios)
                for v=1 : length(fuelAirRatios)
                    groundRollResult = [turbojetGroundRoll.engineCalc(fuelAirRatios(v), bleedRatios(j), 0, compressionRatios(i),afterburnerFuelAirRatios(k), afterburnerCompressionRatios(u)), groundRollResult];
                    cruiseResult = [turbojetCruise.engineCalc(fuelAirRatios(v), bleedRatios(j), 0.86, compressionRatios(i),afterburnerFuelAirRatios(k), afterburnerCompressionRatios(u)), cruiseResult];
                end
            end
        end
    end
end

plot(groundRollResult(:).thrustSpecificFuelConsumption, groundRollResult(:).specificThrust)



end