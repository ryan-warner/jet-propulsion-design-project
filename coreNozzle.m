classdef coreNozzle
    properties
        efficiency
        gamma
        specificHeat
        exitVelocity

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = coreNozzle(efficiency, gamma, pressureInitial, ambientPressure)
            obj.efficiency = efficiency;
            obj.gamma = gamma;
            
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = ambientPressure;

            Mbar = 0.0288;
            R = 8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (1 - obj.efficiency .* (1 - (obj.pressureFinal / obj.pressureInitial) .^ ((obj.gamma - 1) / obj.gamma)));
        end

        function obj = velocityCalc(obj)
            obj.exitVelocity = sqrt(2 .* obj.specificHeat .* (obj.temperatureInitial - obj.temperatureFinal));
        end
    end
end