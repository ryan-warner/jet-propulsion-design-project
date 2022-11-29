classdef afterburner
    properties
        gamma
        efficiency
        fuelHeat
        specificHeat
        fuelAirRatio
        fuelAirRatioAfterburner
        maxTemperatureAfterburner
        stagnationPressureRatio
        R
        
        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = afterburner(gamma, efficiency, fuelAirRatio, fuelAirRatioAfterburner, maxTemperatureAfterburner, fuelHeat, stagnationPressureRatio)
            obj.gamma = gamma;
            obj.efficiency = efficiency;
            obj.fuelAirRatio = fuelAirRatio;
            obj.fuelAirRatioAfterburner = fuelAirRatioAfterburner;
            obj.maxTemperatureAfterburner = maxTemperatureAfterburner;
            obj.fuelHeat = fuelHeat;
            obj.stagnationPressureRatio = stagnationPressureRatio;

            Mbar =  0.0288;
            obj.R =  8.3145 ./ Mbar;
            obj.specificHeat = obj.R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            %obj.temperatureFinal = (((obj.efficiency * obj.fuelAirRatioAfterburner * obj.fuelHeat * (1 + obj.gamma)) / (obj.gamma * obj.R)) + (obj.temperatureInitial * (1 + obj.fuelAirRatio))) / (1 + obj.fuelAirRatio + obj.fuelAirRatioAfterburner);
            obj.temperatureFinal = (obj.fuelAirRatioAfterburner * obj.fuelHeat * obj.efficiency + (1 + obj.fuelAirRatio) * obj.specificHeat * obj.temperatureInitial) / (obj.specificHeat * (1 + obj.fuelAirRatio + obj.fuelAirRatioAfterburner));
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.stagnationPressureRatio * obj.pressureInitial;
        end
    end
end