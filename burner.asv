classdef burner
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

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = burner(stagnationPressureRatio, gamma, efficiency, fuelHeat, fuelAirRatio, maxTemperature, bleedRatio)
            obj.gamma = gamma;
            obj.efficiency = efficiency;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.fuelHeat = fuelHeat;
            obj.fuelAirRatio = fuelAirRatio;
            obj.maxTemperature = maxTemperature;
            obj.bleedRatio = bleedRatio;
            
            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.maxFuelAirRatio = ((obj.maxTemperature/obj.temperatureInitial - 1) / (((obj.efficiency * obj.fuelHeat) / (obj.temperatureInitial * obj.specificHeat)) - (obj.maxTemperature / obj.temperatureInitial)));
            obj.temperatureFinal = 10 .^3 .* (1 + (obj.fuelAirRatio .* obj.efficiency .* obj.fuelHeat) ./ (obj.specificHeat * obj.temperatureInitial)) ./ (1 + obj.fuelAirRatio);
            
            %obj.temperatureFinal = (obj.efficiency * obj.fuelAirRatio * obj.fuelHeat * (obj.gamma - 1) + obj.temperatureInitial * (1 - obj.bleedRatio)) / (1 + obj.fuelAirRatio - obj.bleedRatio);
            if obj.temperatureFinal > obj.maxTemperature
                %obj.temperatureFinal = 0;
            end
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = pressureInitial .* obj.stagnationPressureRatio;
        end

    end
end