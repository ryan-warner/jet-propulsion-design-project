classdef ramjet
    properties
        fuelAirRatio
        bleedRatio
        flightMach

        % Required Components
        diffuser
        combustor
        nozzle

        ambientPressure
        ambientTemperature
        
        % Performance Parameters
        exitPressure
        exitTemperature
    end

    methods
        function obj = ramjet(ambientPressure, ambientTemperature)
            obj.ambientPressure = ambientPressure;
            obj.ambientTemperature = ambientTemperature;

            % Create Stages
            obj.diffuser = diffuser(0.92, 1.4);
            obj.combustor = burner(0.98, 1.33, 0.99, 45000000, 0.12, 700);
            obj.nozzle = coreNozzle(0.95, 1.35, obj.ambientPressure);
        end

        function obj = engineCalc(obj, fuelAirRatio, bleedRatio, flightMach)
            obj.fuelAirRatio = fuelAirRatio;
            obj.flightMach = flightMach;
            obj.bleedRatio = bleedRatio;

            % Stage Calculations
            obj.diffuser = obj.diffuser.temperatureChange(obj.ambientTemperature, obj.flightMach);
            obj.diffuser = obj.diffuser.pressureChange(obj.ambientPressure);

            obj.combustor = obj.combustor.temperatureChange(obj.diffuser.temperatureFinal, 1300, obj.bleedRatio, obj.fuelAirRatio);
            obj.combustor = obj.combustor.pressureChange(obj.diffuser.pressureFinal);
            obj.combustor = obj.combustor.maxFuelAirRatioCalc();

            obj.nozzle = obj.nozzle.temperatureChange(obj.combustor.temperatureFinal, obj.combustor.pressureFinal);
            obj.nozzle = obj.nozzle.velocityCalc();

            prettyPrint({obj.diffuser, obj.combustor, obj.nozzle})
        end
    end

end