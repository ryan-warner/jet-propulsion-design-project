classdef turbine
    properties
        stagnationTemperatureRatio
        polytropicEfficiency
        gamma
        efficiency
        specificHeat
        maxTemperature
        maxBleedRatio
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
        function obj = turbine(polytropicEfficiency, gamma, maxTemperature, maxBleedRatio, cBeta1, workrate, flowrate, stagnationTemperatureRatio, fuelAirRatio)
            obj.stagnationTemperatureRatio = stagnationTemperatureRatio;
            obj.polytropicEfficiency = polytropicEfficiency;
            obj.efficiency = (obj.stagnationTemperatureRatio - 1) ./ (obj.stagnationTemperatureRatio .^(1/obj.polytropicEfficiency) - 1);
            obj.gamma = gamma;
            obj.maxTemperature = maxTemperature;
            obj.maxBleedRatio = maxBleedRatio;
            obj.cBeta1 = cBeta1;
            obj.workrate = workrate;
            obj.flowrate = flowrate;
            obj.fuelAirRatio = fuelAirRatio;

            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial - ((obj.workrate / obj.flowrate) / (obj.specificHeat * (1 + obj.fuelAirRatio - obj.maxBleedRatio)));
        end
    
        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial * (obj.temperatureFinal / obj.temperatureInitial)^(obj.gamma / (obj.efficiency * (obj.gamma - 1)));
        end
    end

end