# ----- Remove modules to be copied
Remove-item -Path '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules\Dynamics365' -Recurse -Force
Remove-item -Path '\\sl-dsc.stratuslivedemo.com\c$\PSModules\Dynamics365' -Recurse -Force






# ----- Copy Dynamics module to DSC server for distribution
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Dynamics365' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Copy-item 'F:\github\SQLExtras' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\StratusLive' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Copy-item 'F:\github\LocalSecurityPolicy' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force

# ----- Copy to the share location on DSC
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Dynamics365' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force
Copy-item 'F:\github\SQLExtras' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Stratuslive' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force
Copy-item 'F:\github\LocalSecurityPolicy' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force

Get-date