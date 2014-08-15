<#
Usage: WyseINI.ps1 -s <HQ or RW, wherever the thin client will connect to> -m <MAC address of the thin client> -r <screen resolution you want to set (input width setting only)>
#>
[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline,Mandatory=$true, HelpMessage="Enter HQ or RW to create the INI file on BOS-HQ-WDM or RW-WDM")]
		[Alias("s")]
		[ValidateScript({If ($_ -match '^HQ' -OR '^RW') {
            $True
        } Else {
            Throw "$_ is not a valid WYSE server! Try 'HQ' or 'RW'"
        }})]
		[string] $Server,
		
		[Parameter(Mandatory=$true, HelpMessage = "Please enter a valid MAC address with no semicolons. Example: 008064AAB712 (12 hex digits)")]
		[Alias("m")]
		[ValidatePattern("^[a-f0-9]{12}$")]
		[string] $mac,
		
		[Parameter(ValueFromPipeline,Mandatory=$true, HelpMessage="Enter '1024' or '1280' or '1440' or '1920' to set the resolution of the thin client")]
		[Alias("r")]
		[ValidateScript({If ($_ -match '^1024' -OR '^1152' -OR '^1280' -OR '^1440' -OR '^1680' -OR '^1920') {
            $True
        } Else {
            Throw "$_ is not a valid screen resolution! Try '1024' or '1152' or '1280' or '1440' or '1680' or '1920'"
        }})]
		[string] $Resolution
	)
$Rev =  "v2.1 10 Feb 2014"
#$ErrorActionPreference="continue"
Write-Host @'
 _       ____  _______ ______   _____   ______
| |     / /\ \/ / ___// ____/  /  _/ | / /  _/
| | /| / /  \  /\__ \/ __/     / //  |/ // /  
| |/ |/ /   / /___/ / /___   _/ // /|  // /   
|__/|__/   /_//____/_____/  /___/_/ |_/___/   
                                              
'@
Write-Host $('*' * 44) -Fo Green
Write-Host "$($MyInvocation.MyCommand.Name): Generates a unique config file for a WYSE device" -Fo Green
Write-Host "Written By: Tyler Applebaum" -Fo Green
Write-Host "$Rev" -Fo Green
Write-Host $('*' * 44) -Fo Green `n

#Server selection
If ($Server -like 'HQ'){
$server = "BOS-HQ-WDM"
}

Elseif ($Server -like 'RW'){
$Server = "RW-WDM"
}

#Set mac to uppercase for filename
$MAC = $MAC.ToUpper()

#Resolution Selection
If ($Resolution -like '1024'){
	Write-Host "1024x768 INI file generated on $Server." -fore green`n
	Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1024x768.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
}
Elseif ($Resolution -like '1152'){
	Write-Host "1152x864 INI file generated on $Server." -fore green`n	
	Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1152x864.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
}
Elseif ($Resolution -like '1280'){
	Write-Host "1280x1024 INI file generated on $Server." -fore green`n	
	Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1280x1024.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
}
Elseif ($Resolution -like '1440'){
	Write-Host "1440x900 INI file generated on $Server." -fore green`n
	Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1440x900.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
}
Elseif ($Resolution -like '1680'){
	Write-Host "1680x1050 INI file generated on $Server." -fore green`n
	Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1680x1050.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
}
Elseif ($Resolution -like '1920'){
	Write-Host "1920x1080 INI file generated on $Server." -fore green`n	
	Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1920x1080.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
}

#All lines below should never occur since parameters are mandatory. Was the original version of the script, will leave here for reference.
If (! ($mac)){
	Do {
		$charset = "^[a-f0-9]{12}$"
		$script:MAC = Read-Host "Please enter the MAC address of the thin client"
			if ($MAC -notmatch $charset){
				Write-Host "`nPlease enter a valid MAC address with no semicolons" -back black -fore yellow -nonewline; Write-Host "`tExample: 008064AAB712 (12 hex digits)`n" -fore green
			}
			elseif ($MAC.length -ne "12") {
				Write-Host "`nPlease enter a valid MAC address with no semicolons" -back black -fore yellow -nonewline; Write-Host "`tExample: 008064AAB712 (12 hex digits)`n" -fore green
			}
			else { #continue
			}
	} until ($MAC -match $charset -and $MAC.length -eq "12")
}#endif $mac parameter

If (! ($server)){
	$title = "Server location"
	$message = "Select the location of the VM"
	$1 = New-Object System.Management.Automation.Host.ChoiceDescription "&Raging Wire", `
		"RW-WDM"
	$2 = New-Object System.Management.Automation.Host.ChoiceDescription "&Headquarters", `
		"BOS-HQ-WDM"
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2)
	$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
		switch ($result)
			{
				0 {
				Write-Host "Raging Wire selected" -back black -fore blue`n
				$Server = "RW-WDM"
				}
				1 {
				Write-Host "HQ selected" -back black -fore blue`n	
				$Server = "BOS-HQ-WDM"
				}
			}
}#endif $server parameter

If (! ($resolution)){
	$title = "Resolution Selection"
	$message = "Select the resolution for the thin client"
	$1 = New-Object System.Management.Automation.Host.ChoiceDescription "&XGA 1024x768", `
		"1024x768"
	$2 = New-Object System.Management.Automation.Host.ChoiceDescription "&SXGA 1280x1024", `
		"1280x1024"
	$3 = New-Object System.Management.Automation.Host.ChoiceDescription "&WXGA+ 1440x900", `
		"1440x900"
	$4 = New-Object System.Management.Automation.Host.ChoiceDescription "&FHD 1920x1080", `
		"1920x1080"
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3, $4)
	$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
		switch ($result)
			{
				0 {
				Write-Host "1024x768 INI file generated." -fore green`n
				Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1024x768.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
				}
				1 {
				Write-Host "1280x1024 INI file generated." -fore green`n	
				Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1280x1024.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
				}
				2 {
				Write-Host "1440x900 INI file generated." -fore green`n
				Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1440x900.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
				}
				3 {
				Write-Host "1920x1080 INI file generated." -fore green`n	
				Copy-Item "\\$Server\c$\inetpub\ftproot\Wyse\wlx\1920x1080.ini" "\\$Server\c$\inetpub\ftproot\Wyse\wlx\$MAC.ini"
				}
			}		
}