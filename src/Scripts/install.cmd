reg import parameters.reg
reg import svchost.reg
sc create SvcHostDemo binPath= "%%SystemRoot%%\System32\svchost.exe -k demo" type= share