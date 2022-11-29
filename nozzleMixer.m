classdef nozzleMixer
    properties
        gamma
        bypassRatio
        fuelAirRatio
        afterburnerFARatio

        afterburnerTemperatureFinal
        fanTemperatureFinal

        pressureFinal
        temperatureFinal
    end

    methods
        function obj = nozzleMixer(bypassRatio, fuelAirRatio, afterburnerFARatio, afterburnerTemperatureFinal, fanTemperatureFinal)
            obj.bypassRatio = bypassRatio;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.afterburnerTemperatureFinal = afterburnerTemperatureFinal;
            obj.fanTemperatureFinal = fanTemperatureFinal;
        end

        function obj = temperatureChange(obj)
            obj.temperatureFinal = obj.fanTemperatureFinal + ((obj.afterburnerTemperatureFinal - obj.fanTemperatureFinal) .* ((1 + obj.fuelAirRatio + obj.afterburnerFARatio) / (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio)));
        end

        function obj = gammaCalc(obj)
            obj.gamma = 1.44 - ((1.39 .* 10e-4) .* obj.temperatureFinal) + ((3.57 .* 10e-8) .* ((obj.temperatureFinal) .^2));
            %obj.gamma = 1.36;
        end

        function obj = pressureChange(obj, fanPressureFinal, afterburnerPressureFinal)
            obj.pressureFinal = fanPressureFinal .* (((obj.temperatureFinal ./ obj.fanTemperatureFinal) .^ (obj.gamma ./ (obj.gamma - 1))) .* ((afterburnerPressureFinal ./ fanPressureFinal) .^ ( (1 + obj.fuelAirRatio + obj.afterburnerFARatio) / (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio) )) .* ((obj.fanTemperatureFinal ./ obj.afterburnerTemperatureFinal) .^ ( (obj.gamma .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio)) ./ ((obj.gamma - 1) .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio)) )));
        end
    end
end