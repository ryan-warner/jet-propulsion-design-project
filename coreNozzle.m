classdef coreNozzle
    properties (Constant)
      station = "e"
      name = "Combined Nozzle"
   end
    properties
        efficiency
        gamma
        specificHeat
        exitVelocity

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = coreNozzle(efficiency, gamma, ambientPressure)
            obj.efficiency = efficiency;
            obj.gamma = gamma;
            
            obj.pressureFinal = ambientPressure;

            Mbar = 0.0288;
            R = 8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (1 - obj.efficiency .* (1 - (obj.pressureFinal / obj.pressureInitial) .^ ((obj.gamma - 1) / obj.gamma)));
        end

        function obj = velocityCalc(obj)
            obj.exitVelocity = sqrt(2 .* obj.specificHeat .* (obj.temperatureInitial - obj.temperatureFinal));
        end
    end
end