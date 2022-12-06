classdef afterburner
    properties (Constant)
      station = "6"
      name = "Afterburner"
   end
    properties
        gamma
        efficiency
        fuelHeat
        specificHeat
        fuelAirRatio
        fuelAirRatioAfterburner
        maxTemperatureAfterburner
        stagnationPressureRatio
        R
        afterburnerOn
        
        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
        maxFuelAirRatio
    end

    methods 
        function obj = afterburner(gamma, efficiency, maxTemperatureAfterburner, fuelHeat)
            obj.gamma = gamma;
            obj.efficiency = efficiency;
            obj.maxTemperatureAfterburner = maxTemperatureAfterburner;
            obj.fuelHeat = fuelHeat;

            Mbar =  0.0288;
            obj.R =  8.3145 ./ Mbar;
            obj.specificHeat = obj.R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial, fuelAirRatio, fuelAirRatioAfterburner, afterburnerOn)
            obj.temperatureInitial = temperatureInitial;
<<<<<<< Updated upstream
            if afterburnerOn >= 0.5
                obj.afterburnerOn = true;
                obj.stagnationPressureRatio = 0.97;
            else
                obj.afterburnerOn = false;
                obj.stagnationPressureRatio = 1;
            end
            if obj.afterburnerOn
                obj.fuelAirRatio = fuelAirRatio;
                obj.fuelAirRatioAfterburner = fuelAirRatioAfterburner;
                obj.temperatureFinal = (obj.fuelAirRatioAfterburner * obj.fuelHeat * obj.efficiency + (1 + obj.fuelAirRatio) * obj.specificHeat * obj.temperatureInitial) / (obj.specificHeat * (1 + obj.fuelAirRatio + obj.fuelAirRatioAfterburner));
            else
                obj.temperatureFinal = obj.temperatureInitial;
            end
=======
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.temperatureFinal = (obj.fuelAirRatioAfterburner * obj.fuelHeat * obj.efficiency + (1 + obj.fuelAirRatio) * obj.specificHeat * obj.temperatureInitial) / (obj.specificHeat * (1 + obj.fuelAirRatio + obj.fuelAirRatioAfterburner));

>>>>>>> Stashed changes
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            
            if obj.afterburnerOn
                obj.pressureFinal = obj.stagnationPressureRatio * obj.pressureInitial;
            else
                obj.pressureFinal = obj.pressureInitial;
            end
        end

        function obj = maxFuelAirRatioCalc(obj)
            if obj.afterburnerOn
                obj.maxFuelAirRatio = obj.specificHeat .* (obj.maxTemperatureAfterburner - obj.temperatureInitial) ./ (obj.efficiency .* obj.fuelHeat);
            else
                obj.maxFuelAirRatio = 0;
            end
        end
    end
end