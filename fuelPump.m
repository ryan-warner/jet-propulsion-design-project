classdef fuelPump
    properties
        fuelDensity
        fuelAirRatio
        workBurner
        workAfterburner
        pumpWork
        efficiency
    end

    methods
        function obj = fuelPump(fuelDensity, fuelAirRatio, efficiency)
            obj.fuelDensity = fuelDensity;
            obj.fuelAirRatio = fuelAirRatio;
            obj.efficiency = efficiency;
        end

        function obj = pumpWorkStandard(obj, burnerInletPressure, pumpInletPressure)
            % Added 550 kpa offset
            obj.workBurner = obj.fuelAirRatio .* ((burnerInletPressure + 550000 - pumpInletPressure) / (obj.fuelDensity * obj.efficiency));
            obj.workAfterburner = 0;
            obj.pumpWork = obj.workBurner;
        end

        function obj = pumpWorkAfterburner(obj, burnerInletPressure, pumpInletPressure, afterburnerInletPressure, fuelAirRatioAfterburner)
            obj.workBurner = obj.fuelAirRatio .* ((burnerInletPressure + 550000 - pumpInletPressure) / (obj.fuelDensity * obj.efficiency));
            obj.workAfterburner = (fuelAirRatioAfterburner + obj.fuelAirRatio)  .* ((afterburnerInletPressure + 550000 - pumpInletPressure) / (obj.fuelDensity * obj.efficiency));
            obj.pumpWork = obj.workBurner + obj.workAfterburner;
        end
    end
end