[string]$Path = Read-Host 'Root path to purge from? (\\server\share\folder)'
[int]$NumSubFolders = Read-Host 'Number of subfolders to work in parallel threads? (integer)'
[int]$DaysOld = Read-Host 'Minimum days old subfolders must be to purge? (integer)'

Get-ChildItem -Path $Path | 
Where-Object {
        $_.PSIsContainer -and $_.CreationTime -lt (Get-Date).AddDays(-$DaysOld) 
} | 
Sort CreationTime |
Select -First $NumSubFolders |
ForEach-Object {
    $pscmd= 
    'Write-Host "Deleting from '+$_.FullName+'..."`
    foreach($p in Get-ChildItem -Path '+$_.PSPath+' | Sort name){
        Write-Host "Deleting " $p.FullName
        Remove-Item $p.PSPath -Recurse -Force
    }
    Remove-Item -Path '+$_.FullName+'
    Start-Sleep -s 60'

    start powershell $pscmd
}
Start-Sleep -s 60
