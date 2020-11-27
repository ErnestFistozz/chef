$ErrorActionPreference="Stop";
If(-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent() ).IsInRole( [Security.Principal.WindowsBuiltInRole] “Administrator”)){​​​​​​ 
        throw "Run command in an administrator PowerShell prompt"
}​​​​​​;
If($PSVersionTable.PSVersion -lt (New-Object System.Version("3.0"))){
    ​​​​​​ throw "The minimum version of Windows PowerShell that is required by the script (3.0) does not match the currently running version of Windows PowerShell." 
}​​​​​​;
If(-NOT (Test-Path $env:SystemDrive\'azagent'))
{​​​​​​
    mkdir $env:SystemDrive\'azagent'
}​​​​​​;
cd $env:SystemDrive\'azagent';
for($i=1; $i -lt 100; $i++)
{
    ​​​​​​$destFolder="A"+$i.ToString();
if(-NOT (Test-Path ($destFolder)))
    {
        ​​​​​​mkdir $destFolder;cd $destFolder;break;
    }
​​​​​​}​​​​​​;
Add-Type -AssemblyName System.IO.Compression.FileSystem;
[System.IO.Compression.ZipFile]::ExtractToDirectory( "C:\swd\vsts-agent-win-x64-2.177.0.zip", "$PWD\agent");
.\agent\config.cmd --deploymentgroup --deploymentgroupname "Mad Development Projects" --agent $env:COMPUTERNAME --runasservice --work '_work' --url 'https://dev.azure.com/Nedbank-Limited/' --projectname 'Mad-Development-Projects' --proxyurl http://10.59.9.102:80 --auth PAT --token 6qxae36ydgk5h2kcldyam6yeh3bymp65vmercjpazwjbswfcrv2a;