function testClasses

testDiffuser = diffuser(0.92, 1.4, 2);

testDiffuser.diffuserEfficiency
testDiffuser.ramDrag

testDiffuser = testDiffuser.temperatureChange(92)
testDiffuser.pressureChange(429)

testFan = fan(0.2, 1.2, 1.4, 0.8)

testCompressor = compressor(1.2, 1.4, 0.9)

testBurner = burner(1.2, 1.4, 1, 45, 0.9)


end