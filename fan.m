classdef fan
    properties
        polytropicEfficiency
        stagnationPressureRatio
        efficiency
        gamma
        cBeta1
        
        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = fan(fanPolytropicEfficiency, stagnationPressureRatio, gamma, cBeta1)
            obj.polytropicEfficiency = fanPolytropicEfficiency;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.gamma = gamma;
            obj.cBeta1 = cBeta1;
            %do we even need this??
            obj.efficiency = ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ obj.gamma)) - 1) ./ ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ (obj.gamma .* obj.polytropicEfficiency))) - 1);
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (obj.stagnationPressureRatio .^ ((obj.gamma - 1) / (obj.gamma .* obj.polytropicEfficiency)));
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial .* obj.stagnationPressureRatio;
        end
    end
end