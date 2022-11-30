classdef bleedAirMixer
    properties (Constant)
      station = "5.m"
   end
    properties
        gamma
        bleedRatio
        fuelAirRatio

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = bleedAirMixer(gamma, bleedRatio, fuelAirRatio)
            obj.gamma = gamma;
            obj.fuelAirRatio = fuelAirRatio;
            obj.bleedRatio = bleedRatio;
        end

        function obj = temperatureChange(obj, temperatureInitial, compressorExitTemperature)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = ((1 + obj.fuelAirRatio - obj.bleedRatio) * obj.temperatureInitial + compressorExitTemperature * obj.bleedRatio) / (1 + obj.fuelAirRatio);
        end
        
        function obj = pressureChange(obj, pressureInitial, compressorExitTemperature)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial * ((obj.temperatureFinal / obj.temperatureInitial)^(obj.gamma / (obj.gamma - 1))) * ((obj.temperatureInitial / compressorExitTemperature)^((obj.gamma * obj.bleedRatio) / ((obj.gamma - 1) * (1 + obj.fuelAirRatio))));
        end

    end
end