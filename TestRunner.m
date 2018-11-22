import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin


% suiteFile = TestSuite.fromFile('MatlabKodeTestSuite/UutReader.m');
suiteFile = TestSuite.fromFolder('MatlabKodeTestSuite');
runner = TestRunner.withTextOutput;

runner.addPlugin(CodeCoveragePlugin.forFolder(pwd))
result = runner.run(suiteFile);


numberPassedTest = 0;
numberFailedTest = 0;

for i = 1: length(result)
     if(result(i).Passed == 1)
         numberPassedTest = numberPassedTest + 1;
     end
end

numberFailedTest = length(result)-numberPassedTest;
