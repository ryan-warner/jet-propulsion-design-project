function engineTests
ramjetInstance = ramjet(10000, 220);
ramjetInstance = ramjetInstance.engineCalc(0.018, 1.5);

turbofanInstance = turbofan(1000000, 285);
turbofanInstance = turbofanInstance.engineCalc(0.1, 0.3, 0, 1.1, 10, 25, 0.02, 0.97);

turbofanInstance = turbofanInstance.engineCalc(0.15, 0.12, 0, 1.5, 13, 40, 0.02, 0.97)


turbojetInstance = turbojet(10000, 220);
turbojetInstance = turbojetInstance.engineCalc(0.018, 0.1, 1.5, 30, 0.01, 0.97);

end