classdef fanNozzle
    properties
        efficiency
        gamma
        specificHeat
        exitVelocity

        pressureFinal
        temperatureFinal
    end

    methods
        function obj = fanNozzle(efficiency, gamma, ambientPressure)
            obj.efficiency = efficiency;
            obj.gamma = gamma;
            obj.pressureFinal = ambientPressure;

            Mbar = 0.0288;
            R = 8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, fanPressureFinal, fanTemperatureFinal)
            obj.temperatureFinal = fanTemperatureFinal .* (1 - obj.efficiency .* (1 - (obj.pressureFinal / fanPressureFinal) .^ ((obj.gamma - 1) / obj.gamma)));
        end

        function obj = velocityCalc(obj, fanTemperatureFinal)
            obj.exitVelocity = sqrt(2 .* obj.specificHeat .* (fanTemperatureFinal - obj.temperatureFinal));
        end
    end
end