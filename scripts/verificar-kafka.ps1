$broker = "campuslab-kafka-lab-kafka1-1"
$bootstrap = "kafka1:29092"

Write-Host "`n=== TOPICOS DE KAFKA ==="
docker exec $broker kafka-topics --bootstrap-server $bootstrap --list

foreach ($topic in @("campuslab.booking.events", "campuslab.occupancy.events")) {
    Write-Host "`n=== CONFIGURACION: $topic ==="
    docker exec $broker kafka-topics --bootstrap-server $bootstrap --describe --topic $topic
}

Write-Host "`n=== GRUPOS CONSUMIDORES ==="
docker exec $broker kafka-consumer-groups --bootstrap-server $bootstrap --list
