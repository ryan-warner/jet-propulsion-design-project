classdef separateNozzle
    properties
        comboNozzExitVelocity
        gamma
        fuelAirRatio
        afterburnerFARatio
        bypassRatio
        u
        fuelHeat
        specificDragLoss
        coreNozzExitVelocity
        fanNozzExitVelocity
        specificHeat

        thermalEfficiency
        propulsiveEfficiency
        overallEfficiency
        ST
        TSFC
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
            obj.thermalEfficiency = ((1 + obj.fuelAirRatio + obj.afterburnerFARatio) .* ((obj.coreNozzExitVelocity .^ 2)) + (obj.bypassRatio .* (obj.fanNozzExitVelocity .^ 2)) - (((1 + obj.bypassRatio) .* (obj.u .^2)))) ./ ((obj.fuelAirRatio + obj.afterburnerFARatio) .* obj.fuelHeat .* 2);
        end

        function obj = propulsiveEfficiencyCalc(obj)
            obj.propulsiveEfficiency = obj.ST .* (2 / ((1 + obj.fuelAirRatio + obj.afterburnerFARatio) .* ((obj.coreNozzExitVelocity .^ 2)) + (obj.bypassRatio .* (obj.fanNozzExitVelocity .^ 2)) - (((1 + obj.bypassRatio) .* (obj.u .^2))))); 
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