classdef nozzleMixer
    properties
        gamma
        bypassRatio

        pressureFinal
        temperatureFinal
    end

    methods
        function obj = nozzleMixer(gamma, bypassRatio)
            obj.gamma = gamma;
            obj.bypassRatio = bypassRatio;
        end

        function obj = temperatureChange()
            obj.temperatureFinal
        end

        function obj = pressureChange()
            obj.pressureFinal
        end
    end
end