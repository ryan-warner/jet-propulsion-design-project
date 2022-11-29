classdef compressor
    properties
        stagnationPressureRatio
        polytropicEfficiency
        gamma
        efficiency

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = compressor(stagnationPressureRatio, gamma, polytropicEfficiency)
            obj.gamma = gamma;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.polytropicEfficiency = polytropicEfficiency;
            obj.efficiency = ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ obj.gamma)) - 1) ./ ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ (obj.gamma * obj.polytropicEfficiency))) - 1);
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (1 + (((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ obj.gamma)) - 1) ./ obj.efficiency))
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial .* obj.stagnationPressureRatio;
        end

    end


end