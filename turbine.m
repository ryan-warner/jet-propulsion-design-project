classdef turbine
    properties (Constant)
      station = "5.1"
      name = "Turbine"
   end
    properties
        stagnationTemperatureRatio
        polytropicEfficiency
        gamma
        efficiency
        specificHeat
        maxTemperature
        bleedRatio
        cBeta1
        workrate
        flowrate
        fuelAirRatio

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = turbine(polytropicEfficiency, gamma, maxTemperature, bleedRatio, cBeta1, workrate, fuelAirRatio)
            obj.polytropicEfficiency = polytropicEfficiency;
            obj.gamma = gamma;
            obj.maxTemperature = maxTemperature;
            obj.bleedRatio = bleedRatio;
            obj.cBeta1 = cBeta1;
            obj.workrate = workrate;
            obj.fuelAirRatio = fuelAirRatio;

            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial, compressorTemperatureInitial, compressorTemperatureFinal, compressorSpecificHeat)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial - (((compressorTemperatureFinal - compressorTemperatureInitial) * compressorSpecificHeat) / (obj.specificHeat * (1 + obj.fuelAirRatio - obj.bleedRatio)));
            obj.stagnationTemperatureRatio = obj.temperatureFinal / obj.temperatureInitial;
            obj.efficiency = (obj.stagnationTemperatureRatio - 1) ./ (obj.stagnationTemperatureRatio .^(1 / obj.polytropicEfficiency) - 1);
        end
    
        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial * (obj.temperatureFinal / obj.temperatureInitial)^(obj.gamma / (obj.polytropicEfficiency * (obj.gamma - 1)));
        end
    end

end