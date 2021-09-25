function PS-Admin {
    Start-Process powershell.exe -Verb RunAs
    Set-ExecutionPolicy Unrestricted -force
}

function Activate-WSL {
    Write-Host "`nThe computer is going to be restarted"
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /Quiet
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
    Write-Host "`t1. Configure Powershell"
    Write-Host "`t2. Configure WSL characteristics (Restart)"
    Write-Host "`t3. Update WSL to WSL2"
    Write-Host "`t0. Exit"
    Write-Host "========================================================"
    $choice = Read-Host "`nEnter Choice: "

    switch ($choice) {
    '1'{
        PS-Admin
        Main
    }
    '2'{
        Activate-WSL -Comfirm
    }
    '3'{
        Update-WSL
        Main
    }
    '0'{
        Return
        }
    }
}

Main



