classdef nozzleMixer
    properties (Constant)
      station = "7"
      name = "Nozzle Mixer"
   end
    properties
        gamma
        bypassRatio
        fuelAirRatio
        afterburnerFARatio
        stagnationPressureRatio

        afterburnerTemperatureFinal
        fanTemperatureFinal

        pressureFinal
        temperatureFinal
    end

    methods
        function obj = nozzleMixer(bypassRatio, fuelAirRatio, afterburnerFARatio, afterburnerTemperatureFinal, fanTemperatureFinal, stagnationPressureRatio)
            obj.bypassRatio = bypassRatio;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.afterburnerTemperatureFinal = afterburnerTemperatureFinal;
            obj.fanTemperatureFinal = fanTemperatureFinal;
            obj.stagnationPressureRatio = stagnationPressureRatio;
        end

        function obj = temperatureChange(obj)
            obj.temperatureFinal = obj.fanTemperatureFinal + ((obj.afterburnerTemperatureFinal - obj.fanTemperatureFinal) .* ((1 + obj.fuelAirRatio + obj.afterburnerFARatio) / (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio)));
        end

        function obj = gammaCalc(obj)
            obj.gamma = 1.44 - ((1.39e-4) .* obj.temperatureFinal) + ((3.57e-8) .* (obj.temperatureFinal .^2));
        end

        function obj = pressureChange(obj, fanPressureFinal, afterburnerPressureFinal)
            obj.pressureFinal = obj.stagnationPressureRatio .* fanPressureFinal .* (((obj.temperatureFinal ./ obj.fanTemperatureFinal) .^ (obj.gamma ./ (obj.gamma - 1))) .* ((afterburnerPressureFinal ./ fanPressureFinal) .^ ( (1 + obj.fuelAirRatio + obj.afterburnerFARatio) / (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio) )) .* ((obj.fanTemperatureFinal ./ obj.afterburnerTemperatureFinal) .^ ( (obj.gamma .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio)) ./ ((obj.gamma - 1) .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio)) )));
        end
    end
end