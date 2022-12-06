classdef separateNozzle
    properties
        gamma
        fuelAirRatio
        afterburnerFARatio
        bypassRatio
        u
        fuelHeat
        specificDragLoss
        coreNozzExitVelocity
        fanNozzExitVelocity

        thermalEfficiency
        propulsiveEfficiency
        overallEfficiency
        ST
        TSFC
        Cbeta1
        M
    end

    methods
        function obj = separateNozzle(fuelAirRatio, afterburnerFARatio, bypassRatio, u, fuelHeat, coreNozzExitVelocity, fanNozzExitVelocity, flightMach)
            obj.fuelAirRatio = fuelAirRatio;
            obj.afterburnerFARatio = afterburnerFARatio;
            obj.bypassRatio = bypassRatio;
            obj.u = u;
            obj.M = flightMach;
            obj.fuelHeat = fuelHeat;
            obj.coreNozzExitVelocity = coreNozzExitVelocity;
            obj.fanNozzExitVelocity = fanNozzExitVelocity;
            obj.Cbeta1 = 0.245;
        end

        function obj = thermalEfficiencyCalc(obj)
            obj.thermalEfficiency = ((1 + obj.fuelAirRatio + obj.afterburnerFARatio) .* ((obj.coreNozzExitVelocity .^ 2)) + (obj.bypassRatio .* (obj.fanNozzExitVelocity .^ 2)) - (((1 + obj.bypassRatio) .* (obj.u .^2)))) ./ ((obj.fuelAirRatio + obj.afterburnerFARatio) .* obj.fuelHeat .* 2);
        end

        function obj = dragLossCalc(obj, ambientPressure)
            obj.specificDragLoss = obj.Cbeta1 .* (obj.M .^2) .* (ambientPressure ./ 101.325) .* (obj.bypassRatio .^ 1.5);
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