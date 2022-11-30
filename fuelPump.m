classdef fuelPump
    properties
        fuelDensity
        fuelAirRatio
        fuelPumpWork
        efficiency
    end

    methods
        function obj = fuelPump(fuelDensity, fuelAirRatio, efficiency)
            obj.fuelDensity = fuelDensity;
            obj.fuelAirRatio = fuelAirRatio;
            obj.efficiency = efficiency;
        end

        function obj = pumpWork(obj, burnerInletPressure, pumpInletPressure)
            % Added 550 kpa offset
            obj.fuelPumpWork = obj.fuelAirRatio .* ((burnerInletPressure + 550000 - pumpInletPressure) / (obj.fuelDensity * obj.efficiency));
        end
    end
end