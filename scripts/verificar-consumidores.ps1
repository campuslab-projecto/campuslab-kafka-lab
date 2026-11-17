$broker = "campuslab-kafka-lab-kafka1-1"
$bootstrap = "kafka1:29092"

$groups = @(
    "campuslab-audit-group",
    "campuslab-report-group"
)

foreach ($group in $groups) {
    Write-Host "`n=== GRUPO: $group ==="

    docker exec $broker kafka-consumer-groups `
        --bootstrap-server $bootstrap `
        --describe `
        --group $group
}
