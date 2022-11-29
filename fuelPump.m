classdef fuelPump
    properties
        fuelDensity
        fuelAirRatio
        fuelPumpWork
    end

    methods
        function obj = fuelPump(fuelDensity, fuelAirRatio)
            obj.fuelDensity = fuelDensity;
            obj.fuelAirRatio = fuelAirRatio;
        end

        function obj = pumpWork(obj, burnerExitPressure, fanExitPressure)
            obj.fuelPumpWork = obj.fuelAirRatio .* ((burnerExitPressure - fanExitPressure) / obj.fuelDensity);
        end
    end
end