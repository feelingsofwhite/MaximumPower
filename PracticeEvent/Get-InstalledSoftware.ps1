#CREDIT: http://techibee.com/powershell/powershell-script-to-query-softwares-installed-on-remote-computer/1389

[cmdletbinding()]            

[cmdletbinding()]
param(
 [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
 [string[]]$ComputerName = $env:computername            
)            

begin {
 $UninstallRegKeys= "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall",
                    "SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
}            

process {
 foreach($Computer in $ComputerName) {
  #Write-Verbose "Working on $Computer"
  if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {
   $HKLM   = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computer)
   foreach ($UninstallRegKey in $UninstallRegKeys) {
    $UninstallRef  = $HKLM.OpenSubKey($UninstallRegKey)
    if ($UninstallRef) {
     $Applications = $UninstallRef.GetSubKeyNames()            
     
     foreach ($App in $Applications) {
      $AppRegistryKey  = $UninstallRegKey + "\\" + $App
      $AppDetails   = $HKLM.OpenSubKey($AppRegistryKey)
      $AppGUID   = $App
      $AppDisplayName  = $($AppDetails.GetValue("DisplayName"))
      $AppVersion   = $($AppDetails.GetValue("DisplayVersion"))
      $AppPublisher  = $($AppDetails.GetValue("Publisher"))
      $AppInstalledDate = $($AppDetails.GetValue("InstallDate"))
      $AppUninstall  = $($AppDetails.GetValue("UninstallString"))
      $AppUninstallQuiet  = $($AppDetails.GetValue("QuietUninstallString"))
      if(!$AppDisplayName) { continue }
      $OutputObj = New-Object -TypeName PSobject
      $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()
      $OutputObj | Add-Member -MemberType NoteProperty -Name AppName -Value $AppDisplayName
      $OutputObj | Add-Member -MemberType NoteProperty -Name AppVersion -Value $AppVersion
      $OutputObj | Add-Member -MemberType NoteProperty -Name AppVendor -Value $AppPublisher
      $OutputObj | Add-Member -MemberType NoteProperty -Name InstalledDate -Value $AppInstalledDate
      $OutputObj | Add-Member -MemberType NoteProperty -Name UninstallKey -Value $AppUninstall
      $OutputObj | Add-Member -MemberType NoteProperty -Name UninstallQuietKey -Value $AppUninstallQuiet
      $OutputObj | Add-Member -MemberType NoteProperty -Name AppGUID -Value $AppGUID
      $OutputObj# | Select ComputerName, DriveName
     }
    }
   }
  }
 }
}            

end {}

