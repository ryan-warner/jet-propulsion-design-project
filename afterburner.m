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

        function obj = temperatureChange(obj, temperatureInitial, fuelAirRatio, fuelAirRatioAfterburner, stagnationPressureRatio)
            obj.fuelAirRatio = fuelAirRatio;
            obj.fuelAirRatioAfterburner = fuelAirRatioAfterburner;
            obj.temperatureInitial = temperatureInitial;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.temperatureFinal = (obj.fuelAirRatioAfterburner * obj.fuelHeat * obj.efficiency + (1 + obj.fuelAirRatio) * obj.specificHeat * obj.temperatureInitial) / (obj.specificHeat * (1 + obj.fuelAirRatio + obj.fuelAirRatioAfterburner));
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.stagnationPressureRatio * obj.pressureInitial;
        end

        function obj = maxFuelAirRatioCalc(obj)
           obj.maxFuelAirRatio = obj.specificHeat .* (obj.maxTemperatureAfterburner - obj.temperatureInitial) ./ (obj.efficiency .* obj.fuelHeat);
        end
    end
end