classdef compressor
    properties (Constant)
      station = "3"
      name = "Compressor"
   end
    properties
        stagnationPressureRatio
        polytropicEfficiency
        gamma
        efficiency
        specificHeat
        work

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = compressor(stagnationPressureRatio, gamma, polytropicEfficiency)
            obj.gamma = gamma;
            obj.stagnationPressureRatio = stagnationPressureRatio;

            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
            obj.polytropicEfficiency = polytropicEfficiency;
            
            %Again, is this needed?
            obj.efficiency = ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ obj.gamma)) - 1) ./ ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ (obj.gamma * obj.polytropicEfficiency))) - 1);
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ (obj.gamma .* obj.polytropicEfficiency)));
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial .* obj.stagnationPressureRatio;
        end

        function obj = workCalc(obj)
            obj.work = obj.specificHeat * (obj.temperatureFinal - obj.temperatureInitial);
        end
    end
end