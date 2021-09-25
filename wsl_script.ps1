function Activate-WSL {
    $title    = 'The computer is going to be restarted'
    $question = 'Are you sure you want to proceed?'
    $choices  = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    if ($decision -eq 0) {
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /Quiet
    } else {
        Main
    }
    
}

function Update-WSL {
    Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -Outfile .\wsl_update_x64.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I wsl_update_x64.msi /quiet'
    Remove-Item .\wsl_update_x64.msi
    wsl --set-default-version 2
    Write-Host "`nWSL2 installed"
}

function Main {
    Write-Host "============= Pick an option=============="
    Write-Host "`t1. Configure WSL characteristics (Restart)"
    Write-Host "`t2. Update WSL to WSL2"
    Write-Host "`t0. Exit"
    Write-Host "========================================================"
    $choice = Read-Host "`nEnter Choice: "

    switch ($choice) {
    '1'{
        Activate-WSL
    }
    '2'{
        Update-WSL
        Main
    }
    '0'{
        Return
        }
    }
}

function Set-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Set-Admin) -eq $false)  {
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""$DesktopPath\wsl_script.ps1""' -Verb RunAs}"
    exit
}

Main
