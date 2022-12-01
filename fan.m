classdef fan
    properties (Constant)
      station = "3f";
      name = "Fan"
   end
    properties
        polytropicEfficiency
        stagnationPressureRatio
        efficiency
        gamma
        cBeta1
        work
        beta
        specificHeat
        
        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = fan(fanPolytropicEfficiency, gamma, cBeta1)
            obj.polytropicEfficiency = fanPolytropicEfficiency;
            obj.gamma = gamma;
            obj.cBeta1 = cBeta1;    

            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial, beta, stagnationPressureRatio)
            obj.beta = beta;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            %do we even need this??
            obj.efficiency = ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ obj.gamma)) - 1) ./ ((obj.stagnationPressureRatio .^ ((obj.gamma - 1) ./ (obj.gamma .* obj.polytropicEfficiency))) - 1);
            
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (obj.stagnationPressureRatio .^ ((obj.gamma - 1) / (obj.gamma .* obj.polytropicEfficiency)));
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial .* obj.stagnationPressureRatio;
        end

        function obj = workCalc(obj)
            obj.work = (1 + obj.beta) .* obj.specificHeat .* (obj.temperatureFinal - obj.temperatureInitial);
        end
    end
end