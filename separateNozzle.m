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
        function obj = separateNozzle(gamma, comboNozzExitVelocity, fuelAirRatio, afterburnerFARatio, bypassRatio, u, fuelHeat, coreNozzExitVelocity, fanNozzExitVelocity, specificDragLoss)
            obj.gamma = gamma;
            obj.comboNozzExitVelocity = comboNozzExitVelocity;
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.bypassRatio = bypassRatio;
            obj.u = u;
            obj.fuelHeat = fuelHeat;
            obj.coreNozzExitVelocity = coreNozzExitVelocity;
            obj.fanNozzExitVelocity = fanNozzExitVelocity;
            obj.specificDragLoss = specificDragLoss;

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

        function obj = specificThrustCalc(obj)
            obj.ST = (((1 + obj.fuelAirRatio + obj.afterburnerFARatio) .* obj.coreNozzExitVelocity) + (obj.bypassRatio .* obj.fanNozzExitVelocity) - ((1 + obj.bypassRatio) .* obj.u)) - obj.specificDragLoss;
        end

        function obj = TSFCCalc(obj)
            obj.TSFC = (obj.fuelAirRatio + obj.afterburnerFARatio) ./ obj.ST;
        end

        function obj = efficiencyCalc(obj)
            obj.overallEfficiency = obj.u ./ (obj.TSFC .* obj.fuelHeat);
        end
    end
end