classdef burner
    properties
        stagnationPressureRatio
        gamma
        efficiency
        fuelHeat
        specificHeat
        fuelAirRatio

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = burner(stagnationPressureRatio, gamma, efficiency, fuelHeat, fuelAirRatio)
            obj.gamma = gamma;
            obj.efficiency = efficiency;
            obj.stagnationPressureRatio = stagnationPressureRatio;
            obj.fuelHeat = fuelHeat;
            obj.fuelAirRatio = fuelAirRatio;
            
            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = 10 .^3 .* (1 + (obj.fuelAirRatio .* obj.efficiency .* obj.fuelHeat) ./ (obj.specificHeat * obj.temperatureInitial)) ./ (1 + obj.fuelAirRatio);
        end

        function obj = pressureRatio(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = pressureInitial .* obj.stagnationPressureRatio;
        end

    end
end