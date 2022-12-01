function engineTests
ramjetInstance = ramjet(10000, 220);
ramjetInstance = ramjetInstance.engineCalc(0.018, 0.1, 1.5);

turbofanInstance = turbofan(10000, 220);
turbofanInstance = turbofanInstance.engineCalc(0.018, 0.1, 1.5, 1.2, 2, 30, 0.01, 0.97);

turbojetInstance = turbojet(10000, 220);
turbojetInstance = turbojetInstance.engineCalc(0.018, 0.1, 1.5, 30, 0.01, 0.97);

end