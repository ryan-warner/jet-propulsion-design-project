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
            eq=obj.engine.turbojetThrustWrapper(x) - obj.reqThrust;
            ineq=[];
        end
    end

end