classdef afterburner
    properties
        gamma
        efficiency
        fuelHeat
        specificHeat
        fuelAirRatio
        fuelAirRatioAfterburner
        maxTemperatureAfterburner
        R
        
        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = afterburner(gamma, efficiency, fuelAirRatio, fuelAirRatioAfterburner, maxTemperatureAfterburner)
            obj.gamma = gamma;
            obj.efficiency = efficiency;
            obj.fuelAirRatio = fuelAirRatio;
            obj.fuelAirRatioAfterburner = fuelAirRatioAfterburner;
            obj.maxTemperatureAfterburner = maxTemperatureAfterburner;

            Mbar =  0.0288;
            obj.R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = 
            
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            
        end
    end
end