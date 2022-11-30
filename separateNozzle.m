classdef separateNozzle
    properties
        comboNozzExitVelocity
        fuelAirRatio
        afterburnerFARatio
        bypassRatio
        u
        fuelHeat
        effectiveSpecificThrust
        specificDragLoss
        coreNozzExitVelocity
        fanNozzExitVelocity

        thermalEfficiency
        propulsiveEfficiency
        overallEfficiency
        ST
        TSFC
    end

    methods
        function obj = separateNozzle(comboNozzExitVelocity, fuelAirRatio, afterburnerFARatio, bypassRatio, u, fuelHeat)
            obj.comboNozzExitVelocity = comboNozzExitVelocity;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.bypassRatio = bypassRatio;
            obj.u = u;
            obj.fuelHeat = fuelHeat;
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
    end
end