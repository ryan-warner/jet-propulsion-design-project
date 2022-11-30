function result = prettyPrint(stages)
    result = table();
    result.("TAmb") = [stages{1,1}.temperatureInitial];
    result.("PAmb") = [stages{1,1}.pressureInitial];
    for stage = stages
        result.(sprintf("T0%s",stage{1}.station)) = [stage{1}.temperatureFinal];
        result.(sprintf("P0%s",stage{1}.station)) = [stage{1}.pressureFinal];
    end
end