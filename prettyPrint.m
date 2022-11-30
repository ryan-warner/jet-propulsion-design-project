function result = prettyPrint(stages)
    result = table();
    result.("TAmb (K)") = [round(stages{1,1}.temperatureInitial,2)];
    result.("PAmb (kPa)") = [round(stages{1,1}.pressureInitial / 1000, 2)];
    for stage = stages
        result.(sprintf("T0%s - %s (K)",stage{1}.station, stage{1}.name)) = [round(stage{1}.temperatureFinal, 2)];
        result.(sprintf("P0%s - %s (kPa)",stage{1}.station, stage{1}.name)) = [round(stage{1}.pressureFinal / 1000, 2)];
    end
end