classdef bleedAirMixer
    properties
        gamma
        maxBleedRatio
        fuelAirRatio

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = bleedAirMixer(gamma, maxBleedRatio, fuelAirRatio)
            obj.gamma = gamma;
            obj.fuelAirRatio = fuelAirRatio;
            obj.maxBleedRatio = maxBleedRatio;
        end

        function obj = temperatureChange(obj, temperatureInitial, compressorExitTemperature)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = ((1 + obj.fuelAirRatio - obj.maxBleedRatio) * obj.temperatureInitial - compressorExitTemperature * obj.maxBleedRatio) / (1 + obj.fuelAirRatio);
        end
        
        function obj = pressureChange(obj, pressureInitial, compressorExitTemperature)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial * ((obj.temperatureFinal / obj.temperatureInitial)^(obj.gamma / (obj.gamma - 1))) * ((obj.temperatureInitial / compressorExitTemperature)^((obj.gamma * obj.maxBleedRatio) / (obj.gamma * (1 + obj.fuelAirRatio))));
        end

    end
end