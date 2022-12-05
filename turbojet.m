classdef turbojet
    properties
        flightMach
        airspeed
        fuelAirRatio
        bleedRatio
        compressorStagnationPressureRatio
        fuelAirRatioAfterburner
        stagnationPressureRatioAfterburner

        % Required Components
        diffuser
        compressor
        combustor
        turbine
        bleedAirMixer
        coreNozzle

        % Optional Components
        afterburner

        % Performance Parameters
        exitPressure
        exitTemperature
        ambientPressure
        ambientTemperature
        specificThrust
        thrustSpecificFuelConsumption
        maxFuelAirRatio
    end

    methods
        function obj = turbojet(ambientPressure, ambientTemperature)
            obj.ambientPressure = ambientPressure;
            obj.ambientTemperature = ambientTemperature;

            % Create Stages
            obj.diffuser = diffuser(0.92, 1.4);
            obj.compressor = compressor(1.38, 0.9);
            obj.combustor = burner(0.98, 1.33, 0.99, 45000000, 0.12, 700);
            obj.turbine = turbine(0.92, 1.33, 1300, 700, 0.12);
            obj.bleedAirMixer = bleedAirMixer(1.34);
            obj.afterburner = afterburner(1.32, 0.96, 2200, 45000000);
            obj.coreNozzle = coreNozzle(0.95, 1.35, obj.ambientPressure);
        end

        function obj = engineCalc(obj, fuelAirRatio, bleedRatio, flightMach, compressorStagnationPressureRatio, fuelAirRatioAfterburner, stagnationPressureRatioAfterburner)
            obj.fuelAirRatio = fuelAirRatio;
            obj.flightMach = flightMach;
            obj.bleedRatio = bleedRatio;
            obj.compressorStagnationPressureRatio = compressorStagnationPressureRatio;
            obj.fuelAirRatioAfterburner = fuelAirRatioAfterburner;
            obj.stagnationPressureRatioAfterburner = stagnationPressureRatioAfterburner;
            obj.airspeed = obj.flightMach * sqrt(1.4 * obj.ambientTemperature * 8.3145 ./ 0.0288);
            
            % Stage Calculations
            obj.diffuser = obj.diffuser.temperatureChange(obj.ambientTemperature, obj.flightMach);
            obj.diffuser = obj.diffuser.pressureChange(obj.ambientPressure);

            obj.compressor = obj.compressor.temperatureChange(obj.diffuser.temperatureFinal, obj.compressorStagnationPressureRatio);
            obj.compressor = obj.compressor.pressureChange(obj.diffuser.pressureFinal);
            obj.compressor = obj.compressor.workCalc();

            obj.combustor = obj.combustor.temperatureChange(obj.compressor.temperatureFinal, 1300, obj.bleedRatio, obj.fuelAirRatio);
            obj.combustor = obj.combustor.pressureChange(obj.compressor.pressureFinal);
            obj.combustor = obj.combustor.maxFuelAirRatioCalc();

            obj.turbine = obj.turbine.temperatureChange(obj.combustor.temperatureFinal, obj.compressor.temperatureInitial, obj.compressor.temperatureFinal, obj.compressor.specificHeat, obj.compressor.work, obj.fuelAirRatio, obj.bleedRatio);
            obj.turbine = obj.turbine.pressureChange(obj.combustor.pressureFinal);

            obj.bleedAirMixer = obj.bleedAirMixer.temperatureChange(obj.turbine.temperatureFinal, obj.compressor.temperatureFinal, obj.bleedRatio, obj.fuelAirRatio);
            obj.bleedAirMixer = obj.bleedAirMixer.pressureChange(obj.turbine.pressureFinal, obj.compressor.temperatureFinal);

            obj.afterburner = obj.afterburner.temperatureChange(obj.bleedAirMixer.temperatureFinal, obj.fuelAirRatio, obj.fuelAirRatioAfterburner, obj.stagnationPressureRatioAfterburner);
            obj.afterburner = obj.afterburner.pressureChange(obj.bleedAirMixer.pressureFinal);
            obj.afterburner = obj.afterburner.maxFuelAirRatioCalc();

            obj.coreNozzle = obj.coreNozzle.temperatureChange(obj.afterburner.temperatureFinal, obj.afterburner.pressureFinal);
            obj.coreNozzle = obj.coreNozzle.velocityCalc();
            obj.coreNozzle = obj.coreNozzle.specificThrustCalc(obj.fuelAirRatio, obj.airspeed);
            obj.coreNozzle = obj.coreNozzle.TSFCCalc();

             % Set Performance Parameters
            %if (imag(obj.coreNozzle.ST) ~= 0)
            %    obj.specificThrust = 0;
            %else
               obj.specificThrust = obj.coreNozzle.ST;
            %end
            obj.thrustSpecificFuelConsumption = obj.coreNozzle.TSFC;
            obj.exitPressure = obj.ambientPressure;
            obj.exitTemperature = obj.coreNozzle.temperatureFinal;
            obj.maxFuelAirRatio = obj.combustor.maxFuelAirRatio;

            prettyPrint({obj.diffuser, obj.compressor, obj.combustor, obj.turbine, obj.bleedAirMixer, obj.afterburner, obj.coreNozzle});
        end

        function result = turbojetWrapper(obj, x) 
            % x is of the form [fuelAirRatio, bleedRatio, flightMach, compressorStagnationPressureRatio, fuelAirRatioAfterburner, stagnationPressureRatioAfterburner]
            result = obj.engineCalc(x(1),x(2),x(3),x(4),x(5),x(6)).thrustSpecificFuelConsumption;
        end

        function result = turbojetThrustWrapper(obj, x)
            % x is of the form [fuelAirRatio, bleedRatio, flightMach, compressorStagnationPressureRatio, fuelAirRatioAfterburner, stagnationPressureRatioAfterburner]
            result = obj.engineCalc(x(1),x(2),x(3),x(4),x(5),x(6)).specificThrust;
        end
    end

end