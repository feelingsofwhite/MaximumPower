##PowerShell Winter Scripting Games Practice Challenge 
#
#v.0
#
#edits made:
# -first version, have a mechanism to get credentials and then gather the first bit of the needed information from the system, the
# next step is for all of this information to be Add-Membered into our collection and then to work out the IP Scanning piece
#   -Stephen @ 8:30 1/4/2014




if ($credential -eq $null){        #Gets credentials on first use
    $credential = Get-Credential
    }



<#need to get
• Hardware information including manufacturer, 
    model, 
    CPU, RAM and disk sizes (only local disks are required).

#>


# Reference of how to use Add-member
#   Add-Member -InputObject $custObj -MemberType NoteProperty -Name "weight" -Value 5

$computer = Add-property (Get-WmiObject win32_computersystem -ComputerName 192.168.2.192 -Credential $credential)

"`$computer currently contains:`n $computer"

Get-WmiObject win32_computersystem -ComputerName 192.168.2.192 -Credential $credential | fl

<#values to get
#IP  Address $CurrentIP
Get-WmiObject win32_ComputerSystem | Select Name,@{n='RAM (MB)';e={[int]($_.TotalPhysicalMemory/1MB)}} 
Get-WmiObject Win32_Processor | select @{n='Processor Type';e="Name"}
Get-WmiObject win32_DiskDrive | select @{n='Disk Model';e="Model"},@{n='Size (GB)';e={[int]($_.Size/1GB)}}

  All above working so far
#>