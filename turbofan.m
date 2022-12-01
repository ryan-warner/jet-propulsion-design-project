classdef turbofan
    properties
        flightMach
        fuelAirRatio
        fuelAirRatioAfterburner
        bleedRatio
        bypassRatio
        fanStagnationPressureRatio
        compressorStagnationPressureRatio
        stagnationPressureRatioAfterburner
        
        % Required Components
        diffuser
        fan
        compressor
        combustor
        turbine
        fanTurbine
        coreNozzle
        fanNozzle

        % Optional Components
        afterburner
        combinedNozzle

        % Virtual Components
        bleedAirMixer
        nozzleMixer

        ambientPressure
        ambientTemperature
        exitPressure
        exitTemperature
    end

    methods
        function obj = turbofan(ambientPressure, ambientTemperature)
            obj.ambientPressure = ambientPressure;
            obj.ambientTemperature = ambientTemperature;

            % Create Stages
            obj.diffuser = diffuser(0.92, 1.4);
            obj.fan = fan(0.90, 1.4, 245);
            obj.compressor = compressor(1.38, 0.9);
            obj.combustor = burner(0.98, 1.33, 0.99, 45000000, 0.12, 700);
            obj.turbine = turbine(0.92, 1.33, 1300, 700, 0.12);
            obj.bleedAirMixer = bleedAirMixer(1.34);
            obj.fanTurbine = fanTurbine(0.92, 1.33, 1.4);
            obj.afterburner = afterburner(1.32, 0.96, 2200, 45000000);
            obj.coreNozzle = coreNozzle(0.95, 1.35, obj.ambientPressure);
            obj.fanNozzle = fanNozzle(0.97, 1.4, obj.ambientPressure);
            obj.nozzleMixer = nozzleMixer(0.80);
            obj.combinedNozzle = combinedNozzle(0.95, 1.37, 45000000, obj.ambientPressure);
        end

        function obj = engineCalc(obj, fuelAirRatio, bleedRatio, flightMach, fanStagnationPressureRatio, bypassRatio, compressorStagnationPressureRatio, fuelAirRatioAfterburner, stagnationPressureRatioAfterburner)
            obj.fuelAirRatio = fuelAirRatio;
            obj.flightMach = flightMach;
            obj.bleedRatio = bleedRatio;
            obj.fanStagnationPressureRatio = fanStagnationPressureRatio;
            obj.compressorStagnationPressureRatio = compressorStagnationPressureRatio;
            obj.bypassRatio = bypassRatio;
            obj.fuelAirRatioAfterburner = fuelAirRatioAfterburner;
            obj.stagnationPressureRatioAfterburner = stagnationPressureRatioAfterburner;
            
            % Stage Calculations
            obj.diffuser = obj.diffuser.temperatureChange(obj.ambientTemperature, obj.flightMach);
            obj.diffuser = obj.diffuser.pressureChange(obj.ambientPressure);

            obj.fan = obj.fan.temperatureChange(obj.diffuser.temperatureFinal, obj.bypassRatio, obj.fanStagnationPressureRatio);
            obj.fan = obj.fan.pressureChange(obj.diffuser.pressureFinal);
            obj.fan = obj.fan.workCalc();

            obj.compressor = obj.compressor.temperatureChange(obj.fan.temperatureFinal, obj.compressorStagnationPressureRatio);
            obj.compressor = obj.compressor.pressureChange(obj.fan.pressureFinal);
            obj.compressor = obj.compressor.workCalc();

            obj.combustor = obj.combustor.temperatureChange(obj.compressor.temperatureFinal, 1300, obj.bleedRatio, obj.fuelAirRatio);
            obj.combustor = obj.combustor.pressureChange(obj.compressor.pressureFinal);
            obj.combustor = obj.combustor.maxFuelAirRatioCalc();

            obj.turbine = obj.turbine.temperatureChange(obj.combustor.temperatureFinal, obj.compressor.temperatureInitial, obj.compressor.temperatureFinal, obj.compressor.specificHeat, obj.compressor.work, obj.fuelAirRatio, obj.bleedRatio);
            obj.turbine = obj.turbine.pressureChange(obj.combustor.pressureFinal);

            obj.bleedAirMixer = obj.bleedAirMixer.temperatureChange(obj.turbine.temperatureFinal, obj.compressor.temperatureFinal, obj.bleedRatio, obj.fuelAirRatio);
            obj.bleedAirMixer = obj.bleedAirMixer.pressureChange(obj.turbine.pressureFinal, obj.compressor.temperatureFinal);
            
            obj.fanTurbine = obj.fanTurbine.temperatureChange(obj.bleedAirMixer.temperatureFinal, obj.fan.temperatureInitial, obj.fan.temperatureFinal, obj.fuelAirRatio, obj.bypassRatio);
            obj.fanTurbine = obj.fanTurbine.pressureChange(obj.bleedAirMixer.pressureFinal);
            obj.fanTurbine = obj.fanTurbine.workCalc();

            obj.afterburner = obj.afterburner.temperatureChange(obj.fanTurbine.temperatureFinal, obj.fuelAirRatio, obj.fuelAirRatioAfterburner, obj.stagnationPressureRatioAfterburner);
            obj.afterburner = obj.afterburner.pressureChange(obj.fanTurbine.pressureFinal);
            obj.afterburner = obj.afterburner.maxFuelAirRatioCalc();

            obj.coreNozzle = obj.coreNozzle.temperatureChange(obj.afterburner.temperatureFinal, obj.afterburner.pressureFinal);
            obj.coreNozzle = obj.coreNozzle.velocityCalc();

            obj.fanNozzle = obj.fanNozzle.temperatureChange(obj.fan.pressureFinal, obj.fan.temperatureFinal);
            obj.fanNozzle = obj.fanNozzle.velocityCalc(obj.fan.temperatureFinal);

            obj.nozzleMixer = obj.nozzleMixer.temperatureChange(obj.bypassRatio, obj.fuelAirRatio, obj.fuelAirRatioAfterburner, obj.afterburner.temperatureFinal, obj.fan.temperatureFinal);
            obj.nozzleMixer = obj.nozzleMixer.gammaCalc();
            obj.nozzleMixer = obj.nozzleMixer.pressureChange(obj.fan.pressureFinal, obj.afterburner.pressureFinal);

            obj.combinedNozzle = obj.combinedNozzle.temperatureChange(obj.nozzleMixer.temperatureFinal, obj.nozzleMixer.pressureFinal, obj.bypassRatio, obj.fuelAirRatio, obj.fuelAirRatioAfterburner, obj.flightMach);

            prettyPrint({obj.diffuser, obj.fan, obj.compressor, obj.combustor, obj.turbine, obj.bleedAirMixer, obj.fanTurbine, obj.afterburner, obj.coreNozzle, obj.fanNozzle, obj.nozzleMixer, obj.combinedNozzle})
        end
    end

end