classdef combinedNozzle
    properties (Constant)
      station = "ec"
   end
    properties
        efficiency
        gamma
        bypassRatio
        fuelAirRatio
        afterburnerFARatio
        specificHeat
        fuelHeat
        R
        u
        M
        ambientPressure

        exitVelocity
        thermalEfficiency
        specificDragLoss
        specificThrust
        propulsiveEfficiency
        overallEfficiency
        TSFC

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods
        function obj = combinedNozzle(efficiency, gamma, bypassRatio, fuelAirRatio, afterburnerFARatio, fuelHeat, M, ambientPressure)
            obj.efficiency = efficiency;
            obj.gamma = gamma;
            obj.bypassRatio = bypassRatio;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.fuelHeat = fuelHeat;
            obj.M = M;
            obj.ambientPressure = ambientPressure;
            obj.pressureFinal = ambientPressure;

            Mbar =  0.0288;
            obj.R =  8.3145 ./ Mbar;
            obj.specificHeat = 0.245;
        end

        function obj = temperatureChange(obj, temperatureInitial, pressureInitial)
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial .* (1- obj.efficiency .* (1 - ( (obj.pressureFinal/ pressureInitial) .^((obj.gamma - 1) ./ obj.gamma) )));
        end

        function obj = exitVelocityCalc(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.exitVelocity = sqrt(2 .* obj.R .* obj.temperatureInitial .* obj.efficiency .* (obj.gamma / (obj.gamma - 1) .* (1 - (obj.ambientPressure / obj.pressureInitial).^ (obj.gamma ./ (obj.gamma - 1)))));
        end

        function obj = thermalEfficiencyCalc(obj)
            obj.u = sqrt(1.4 .* obj.R .* 220) .* obj.M;
            obj.thermalEfficiency = ((1 + obj.fuelAirRatio + obj.bypassRatio + obj.afterburnerFARatio) .* ((obj.exitVelocity .^ 2) ./ 2) - (1 + obj.bypassRatio) .* ((obj.u .^2) ./ 2)) ./ (2 .* obj.fuelHeat * (obj.fuelAirRatio + obj.afterburnerFARatio));
        end

        function obj = dragLossCalc(obj)
            obj.specificDragLoss = obj.specificHeat .* (obj.M .^2) .* (obj.ambientPressure ./ 101.325) .* (obj.bypassRatio .^ 1.5);
        end

        function obj = specificThrustCalc(obj)
            obj.specificThrust = (1 + obj.fuelAirRatio + obj.bypassRatio + obj.afterburnerFARatio) .* obj.exitVelocity - obj.u .* (1 + obj.bypassRatio) - obj.specificDragLoss;
        end

        function obj = propulsiveEfficiencyCalc(obj)
            obj.propulsiveEfficiency = obj.specificThrust .* (obj.u / ((1 + obj.fuelAirRatio + obj.afterburnerFARatio) .* ((obj.exitVelocity .^ 2) ./ 2) - (1 + obj.bypassRatio) .* ((obj.u .^2) ./ 2)));
        end

        function obj = efficiencyCalc(obj)
            obj.overallEfficiency = obj.thermalEfficiency .* obj.propulsiveEfficiency;
        end

        function obj = TSFCCalc(obj)
            obj.TSFC = (obj.fuelAirRatio + obj.afterburnerFARatio) ./ obj.specificThrust;
        end
    end
end