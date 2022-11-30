function result = prettyPrint(stages)
    for stage = stages
        disp(stage.station)
        %result.(stage.station)
    end
end