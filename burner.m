classdef burner
    properties (Constant)
      station = "4"
      name = "Burner"
   end
    properties
        stagnationPressureRatio
        gamma
        efficiency
        fuelHeat
        specificHeat
        fuelAirRatio
        maxTemperature
        maxFuelAirRatio
        bleedRatio
        maxBleedRatio
        cBeta1

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = burner(stagnationPressureRatio, gamma, efficiency, fuelHeat, maxBleedRatio, cBeta1)
            obj.gamma = gamma;
            obj.efficiency = efficiency;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.fuelHeat = fuelHeat;
            obj.maxBleedRatio = maxBleedRatio;
            obj.cBeta1 = cBeta1;
            
            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial, maxTemperature, bleedRatio, fuelAirRatio)
            obj.temperatureInitial = temperatureInitial;
            obj.bleedRatio = bleedRatio;
            obj.fuelAirRatio = fuelAirRatio;
            obj.maxTemperature = maxTemperature + obj.cBeta1 .* sqrt(obj.bleedRatio ./ obj.maxBleedRatio);
            obj.maxFuelAirRatio = ((obj.maxTemperature/obj.temperatureInitial - 1) / (((obj.efficiency * obj.fuelHeat) / (obj.temperatureInitial * obj.specificHeat)) - (obj.maxTemperature / obj.temperatureInitial)));
            obj.temperatureFinal = obj.temperatureInitial .* (((1 - obj.bleedRatio) + (obj.fuelAirRatio .* obj.efficiency .* obj.fuelHeat) ./ (obj.specificHeat  .* obj.temperatureInitial)) ./ ((1 - obj.bleedRatio) + obj.fuelAirRatio));
            
            if obj.temperatureFinal > obj.maxTemperature
                %obj.temperatureFinal = 0;
            end
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = pressureInitial .* obj.stagnationPressureRatio;
        end

        function obj = maxFuelAirRatioCalc(obj)
            obj.maxFuelAirRatio = ((obj.maxTemperature ./ obj.temperatureInitial) - 1) ./ (((obj.efficiency .* obj.fuelHeat) ./ (obj.specificHeat .* obj.temperatureInitial)) - (obj.maxTemperature ./ obj.temperatureInitial));
        end
    end
end