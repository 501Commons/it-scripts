################################
#                              #
# Start-Stop and get status DA #
#                              #
# V1.0 - Lagre                 #
#                              #
################################

function stop-DA {
    Stop-Service iphlpsvc -Force
}

function start-DA {
    Start-Service NcaSvc
    Start-Service iphlpsvc
    Start-Service NcaSvc
}

# menu options
function Show-Menu {
    $service = Get-Service iphlpsvc
    $service.Refresh()


    if ($service.Status -eq 'Running') {
        $status = "DA is Running"
    }

    elseif ($service.Status -eq 'Stopped') {
        $status = "DA is NOT Running"
    }

    param
    (
        [string]$Title = 'DA servicer'
    )

    cls

    Write-Host "================ $Title ================"

    Write-Host "DA Service status = $Status"
     
     

    Write-Host "1: Press '1' to STOP Direct Access"
    Write-Host "2: Press '2' to START Direct Access."
    Write-Host ""
    Write-Host "Q: Press 'Q' to quit."
    Write-Host ""
}

# Options
do {
    Show-Menu
     
    $input = Read-Host "Please make a selection"
     
    switch ($input) {

        '1' { stop-DA }
        
        '2' { start-DA }
        
        'q' {
            cls
            "Bye"

            return
        }
    }
    pause
}
until ($input -eq 'q')