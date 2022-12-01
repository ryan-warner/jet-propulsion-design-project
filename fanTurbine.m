classdef fanTurbine
    properties (Constant)
      station = "5.2"
      name = "Fan Turbine"
   end
    properties
        polytropicEfficiency
        gamma
        efficiency
        specificHeat
        fuelAirRatio
        bypassRatio
        work
        fanSpecificHeat

        pressureInitial
        pressureFinal
        temperatureInitial
        temperatureFinal
    end

    methods 
        function obj = fanTurbine(polytropicEfficiency, gamma, fanGamma)
            obj.gamma = gamma;
            obj.polytropicEfficiency = polytropicEfficiency;
            

            Mbar =  0.0288;
            R =  8.3145 ./ Mbar;
            obj.specificHeat = R .* (obj.gamma ./ (obj.gamma - 1));
            obj.fanSpecificHeat = R .* (fanGamma ./ (fanGamma - 1));
        end

        function obj = temperatureChange(obj, temperatureInitial, fanInletTemperature, fanExitTemperature, fuelAirRatio, bypassRatio)
            obj.fuelAirRatio = fuelAirRatio;
            obj.bypassRatio = bypassRatio;
            obj.temperatureInitial = temperatureInitial;
            obj.temperatureFinal = obj.temperatureInitial - (((1 + obj.bypassRatio) * (fanExitTemperature - fanInletTemperature) * obj.fanSpecificHeat) / (obj.specificHeat * (1 + obj.fuelAirRatio)));
            obj.efficiency = ((obj.temperatureFinal / obj.temperatureInitial) - 1) ./ ((obj.temperatureFinal / obj.temperatureInitial) .^ (1/obj.polytropicEfficiency) - 1);
        end

        function obj = pressureChange(obj, pressureInitial)
            obj.pressureInitial = pressureInitial;
            obj.pressureFinal = obj.pressureInitial * (obj.temperatureFinal / obj.temperatureInitial)^(obj.gamma / (obj.efficiency * (obj.gamma - 1)));
        end

        function obj = workCalc(obj)
            obj.work = obj.specificHeat .* (1 + obj.fuelAirRatio) .* (obj.temperatureInitial - obj.temperatureFinal);
        end
    end

end