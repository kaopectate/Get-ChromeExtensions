Function Get-ChromeExtensions
{
        <#
    .SYNOPSIS
    Gets All installed chrome extensions on a remote computer, requires access to administrative share on remote computer and access to the internet
    to get name of Chrome Extension
    .EXAMPLE
    Get-ChromeExtensions -Name localhost
    .EXAMPLE
    Get-ChromeExtensions -Name comp1,comp2,comp3
    .EXAMPLE
    Get-Content computers.txt | Get-InstalledSoftware | Export-Csv C:\SoftwareReport.csv
    .PARAMETER Name
    One or more computer names seperated by comma.
    #>
        
    [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
            [string[]]$Name
        )
    Begin
    {
        $exclude_list = 
        "pjkljhegncpnkpknbcohdijeoejaedia", #Google Mail 
        "apdfllckaahabafndbhieahigkjlhalf", #Google Drive
        "aohghmighlieiainnegkcijnfilokake", #Google Docs 
        "ghbmnnjooekpmoecnnnilnnbdlolhkhi", #Google Docs Offline
        "felcaaldnbdncclmgdcncolpebgiejap", #Google Sheets
        "aapocclcgogkmnckokdopfmhonfmgoek", #Google Slides
        "blpcfgokakmgnkcojhhkbfbldkacnbeo", #YouTube
        "nmmhkkegccagdldgiimedpiccmgmieda", #Google Wallet
        "mhjfbmdgcfjbbpaeojofohoefgiehjai", #Chrome PDF Viewer
        "pkedcjkdefgpdelpbcmbmeomcjbeemfm", #Chrome Cast
        "Temp"                              #Temp Folder
    }
    Process
    {        
        foreach($comp in $Name)
        {
            $userfolders = (Get-ChildItem "\\$comp\c`$\users" -Directory -Exclude admin,administrator,Public).name
            
            foreach($userfolder in $userfolders)
            {
                if(Test-Path "\\$comp\c`$\users\$userfolder\AppData\Local\Google\Chrome\User Data\Default\Extensions\")
                {
                    $extpaths = (Get-ChildItem "\\$comp\c`$\users\$userfolder\AppData\Local\Google\Chrome\User Data\Default\Extensions\" -Exclude $exclude_list).name
                    
                    foreach($extpath in $extpaths)
                    {
                    Start-Sleep -Seconds 3
                    $get = $null
                    try
                    {
                        $get = (Invoke-WebRequest -uri "https://chrome.google.com/webstore/detail/$extpath" -MaximumRedirection 90)
                        $title = $get.parsedhtml.title
                        $index = $title.length - 19
                        $extensionname = $title.Substring(0,$index)
                    }
                    catch
                    {
                        $extensionname = "Not Found"
                    }
                        $props = [ordered]@{
                            'ComputerName' = $comp;
                            'UserName' = $userfolder;
                            'ExtensionID' = $extpath;
                            'ExtensionName' = $extensionname}
                                                                                     
                        $obj = New-Object -TypeName psobject -Property $props
                        Write-Output $obj
                    }
                                           
                }
            }
        }
    }
}

