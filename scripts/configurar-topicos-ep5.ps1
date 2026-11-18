param(
    [switch]$Aplicar
)

$broker = "campuslab-kafka-lab-kafka1-1"
$bootstrap = "kafka1:29092"

$topicos = @(
    @{ Nombre = "campuslab.booking.events"; Retencion = 604800000 },
    @{ Nombre = "campuslab.occupancy.events"; Retencion = 604800000 },
    @{ Nombre = "campuslab.booking.events.DLT"; Retencion = 1209600000 },
    @{ Nombre = "campuslab.occupancy.events.DLT"; Retencion = 1209600000 }
)

foreach ($topico in $topicos) {

    $nombre = $topico.Nombre
    $retencion = $topico.Retencion

    Write-Host ""
    Write-Host "===== $nombre ====="

    $crear = @(
        "exec", $broker,
        "kafka-topics",
        "--bootstrap-server", $bootstrap,
        "--create",
        "--if-not-exists",
        "--topic", $nombre,
        "--partitions", "3",
        "--replication-factor", "3",
        "--config", "retention.ms=$retencion",
        "--config", "cleanup.policy=delete",
        "--config", "min.insync.replicas=2"
    )

    if ($Aplicar) {
        & docker @crear

        if ($LASTEXITCODE -ne 0) {
            throw "Error al crear el topico $nombre"
        }
    }
    else {
        Write-Host "VISTA PREVIA:"
        Write-Host ("docker " + ($crear -join " "))
    }
}

if (-not $Aplicar) {
    Write-Host ""
    Write-Host "Modo vista previa: no se modificaron topicos."
    Write-Host "Para aplicar: .\scripts\configurar-topicos-ep5.ps1 -Aplicar"
}
