classdef nonLinearThrustConstraint
    properties
        engine
        reqThrust
    end

    methods
        function obj = nonLinearThrustConstraint(engine, reqThrust)
            obj.reqThrust = reqThrust;
            obj.engine = engine;
        end

        function [ineq,eq] = nonLinearFunc(obj, x)
            if abs(obj.engine.turbojetThrustWrapper(x) - obj.reqThrust) < 0.1
                eq=0;
            else
                eq = obj.engine.turbojetThrustWrapper(x) - obj.reqThrust;
            end
            ineq=[];
        end
    end

end