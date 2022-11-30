classdef separateNozzle
    properties
        comboNozzExitVelocity
        gamma
        fuelAirRatio
        afterburnerFARatio
        bypassRatio
        u
        fuelHeat
        effectiveSpecificThrust
        specificDragLoss
        coreNozzExitVelocity
        fanNozzExitVelocity
        specificHeat

        thermalEfficiency
        propulsiveEfficiency
        overallEfficiency
        ST
        TSFC
        maxFARatio
    end

    methods
        function obj = separateNozzle(gamma, comboNozzExitVelocity, fuelAirRatio, afterburnerFARatio, bypassRatio, u, fuelHeat)
            obj.gamma = gamma;
            obj.comboNozzExitVelocity = comboNozzExitVelocity;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.bypassRatio = bypassRatio;
            obj.u = u;
            obj.fuelHeat = fuelHeat;

            Mbar = 0.0288;
            R = 8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
        end

        function obj = thermalEfficiencyCalc(obj)
            obj.thermalEfficiency = ((obj.comboNozzExitVelocity .^2) .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio + obj.bypassRatio) - (obj.u .^2) .* (1 + obj.bypassRatio)) / (2 .* obj.fuelHeat .* (obj.fuelAirRatio + obj.afterburnerFARatio));
        end

        function obj = propulsiveEfficiencyCalc(obj, effectiveSpecificThrust)
            obj.propulsiveEfficiency = effectiveSpecificThrust .* (obj.u / (((obj.comboNozzExitVelocity .^2) / 2) .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio) + obj.bypassRatio .*((obj.comboNozzExitVelocity .^2) / 2) - ((obj.u .^2) / 2) .* (1 + obj.bypassRatio) )); 
        end

        function obj = efficiencyCalc(obj)
            obj.overallEfficiency = obj.thermalEfficiency .* obj.propulsiveEfficiency;
        end

        function obj = specificThrustCalc(obj, specificDragLoss, coreNozzExitVelocity, fanNozzExitVelocity)
            obj.ST = coreNozzExitVelocity .* (1 + obj.fuelAirRatio + obj.afterburnerFARatio) - obj.u .* (1 + obj.bypassRatio) - specificDragLoss + (obj.bypassRatio .* fanNozzExitVelocity);
        end

        function obj = TSFCCalc(obj)
            obj.TSFC = (obj.fuelAirRatio + obj.afterburnerFARatio) ./ obj.ST;
        end

        function obj = maxFuelAirRatioCalc(obj)
            %obj.maxFARatio = ((1 - obj.bypassRatio) .* obj.specificHeat .* compressorTemperatureFinal - obj.specificHeat .* temperatureMax) ./ (obj.specificHeat .* temperatureMax - obj.fuelHeat .* 0.99);
        end
    end
end