# Get-ChromeExtensions
    
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
    
    Install
  Import-Module .\Get-ChromeExtensions.psm1
    
  
