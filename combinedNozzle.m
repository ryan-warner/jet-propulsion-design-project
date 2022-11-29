classdef combinedNozzle
    properties
        efficiency
        gamma
        bypassRatio
        fuelAirRatio
        afterburnerFARatio
        specificHeat
        fuelHeat
        R

        exitVelocity

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = combinedNozzle(efficiency, gamma, bypassRatio, fuelAirRatio, afterburnerFARatio, fuelHeat)
            obj.efficiency = efficiency;
            obj.gamma = gamma;
            obj.bypassRatio = bypassRatio;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterbunerFARatio;
            obj.fuelHeat = fuelHeat;

            Mbar = 0.0288;
            obj.R = 8.3145 ./ Mbar;
            obj.specificHeat = obj.R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureIntial = temperatureInitial;
        end

        function obj = exitVelocityCalc(obj, ambientPressure)
            obj.exitVelocity = sqrt(2 .* obj.R .* obj.temperatureInitial);
        end
    end
end