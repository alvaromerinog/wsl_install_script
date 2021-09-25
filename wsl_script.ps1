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

function Install-Fonts {
    mkdir $DesktopPath\Fonts
    Invoke-WebRequest -Uri "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -Outfile $DesktopPath\Fonts\MesloLGS_NF_Regular.ttf
    Invoke-WebRequest -Uri "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -Outfile $DesktopPath\Fonts\MesloLGS_NF_Bold.ttf
    Invoke-WebRequest -Uri "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -Outfile $DesktopPath\Fonts\MesloLGS_NF_Italic.ttf
    Invoke-WebRequest -Uri "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -Outfile $DesktopPath\Fonts\MesloLGS_NF_Bold_Italic.ttf
    

    $FontsFolder = "$DesktopPath\Fonts"
    $FONTS = 0x14
    $CopyOptions = 4 + 16;
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace($FONTS)
    $allFonts = dir $FontsFolder
    foreach($File in $allFonts)
    {
        echo "Installing $File"
        $CopyFlag = [String]::Format("{0:x}", $CopyOptions);
        $objFolder.CopyHere($File.fullname,$CopyFlag)
    }
    Remove-Item $DesktopPath\Fonts -Recurse -Confirm:$False
    Write-Host "`nMeslo fonts installed"
}

function Main {
    Write-Host "============= Pick an option=============="
    Write-Host "`t1. Configure WSL characteristics (Restart)"
    Write-Host "`t2. Update WSL to WSL2"
    Write-Host "`t3. Install Meslo fonts"
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
    '3'{
        Install-Fonts
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

$DesktopPath = [Environment]::GetFolderPath("Desktop")
if ((Set-Admin) -eq $false)  {
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""$DesktopPath\wsl_script.ps1""' -Verb RunAs}"
    exit
}

Main
