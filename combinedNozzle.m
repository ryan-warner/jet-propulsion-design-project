classdef combinedNozzle
    properties (Constant)
      station = "ec"
      name = "Combined Nozzle"
   end
    properties
        efficiency
        gamma
        bypassRatio
        fuelAirRatio
        afterburnerFARatio
        Cbeta1
        fuelHeat
        R
        u
        M
        ambientPressure

        exitVelocity
        specificDragLoss
        effectiveSpecificThrust
        overallEfficiency
        TSFC

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = combinedNozzle(efficiency, gamma, fuelHeat, ambientPressure)
            obj.efficiency = efficiency;
            obj.gamma = gamma;
            
            obj.fuelHeat = fuelHeat;
            
            obj.ambientPressure = ambientPressure;
            obj.pressureFinal = ambientPressure;

            Mbar =  0.0288;
            obj.R =  8.3145 ./ Mbar;
            obj.Cbeta1 = 0.245;
            obj.u = sqrt(1.4 .* obj.R .* 220) .* obj.M;
        end

        function obj = temperatureChange(obj, temperatureInitial, pressureInitial, bypassRatio, fuelAirRatio, afterburnerFARatio, flightMach)
            obj.bypassRatio = bypassRatio;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.M = flightMach;

            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (1 - obj.efficiency .* (1 - ( (obj.pressureFinal/ pressureInitial) .^((obj.gamma - 1) ./ obj.gamma) )));
        end

        function obj = exitVelocityCalc(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.exitVelocity = sqrt(2 .* obj.R .* obj.temperatureInitial .* obj.efficiency .* (obj.gamma / (obj.gamma - 1) .* (1 - (obj.ambientPressure / obj.pressureInitial).^ ((obj.gamma - 1) ./ obj.gamma))));
        end

        function obj = dragLossCalc(obj)
            obj.specificDragLoss = obj.Cbeta1 .* (obj.M .^2) .* (obj.ambientPressure ./ 101.325) .* (obj.bypassRatio .^ 1.5);
        end

        function obj = specificThrustCalc(obj)
            obj.effectiveSpecificThrust = (1 + obj.fuelAirRatio + obj.bypassRatio + obj.afterburnerFARatio) .* obj.exitVelocity - obj.u .* (1 + obj.bypassRatio) - obj.specificDragLoss;
        end

        function obj = TSFCCalc(obj)
            obj.TSFC = (obj.fuelAirRatio + obj.afterburnerFARatio) ./ obj.effectiveSpecificThrust;
        end

        function obj = efficiencyCalc(obj)
            obj.overallEfficiency = obj.u ./ (obj.TSFC .* obj.fuelHeat);
        end
    end
end