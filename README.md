
# CampusLab - Kafka con ZooKeeper

Laboratorio de infraestructura Kafka para la Evaluación Parcial 5 de CampusLab.

## Arquitectura

El entorno está implementado mediante Docker Compose y contiene:

- 1 servidor Apache ZooKeeper.
- 3 brokers Apache Kafka.
- 1 interfaz Kafka-UI para administración y monitoreo.

## Configuración

- Particiones del tópico de prueba: 3.
- Factor de replicación: 3.
- Réplicas mínimas sincronizadas: 2.
- Retención de mensajes: 7 días.
- Política de limpieza: delete.

Tópico utilizado para las pruebas:

`campuslab.ep5.zookeeper.test`

## Ejecución

Con Docker Desktop iniciado, ejecutar:

```bash
docker compose up -d
```

Acceder a Kafka-UI:

http://localhost:8088

Para revisar los contenedores:

```bash
docker compose ps
```

## Pruebas realizadas

1. Verificación de los tres brokers registrados en ZooKeeper.
2. Creación de un tópico con tres particiones y replicación 3.
3. Publicación y lectura de mensajes.
4. Detención controlada del broker 3.
5. Verificación de la continuidad del liderazgo de las particiones.
6. Publicación de un mensaje durante la caída del broker.
7. Lectura de mensajes con el broker 3 detenido.
8. Reinicio del broker y recuperación de las nueve réplicas sincronizadas.

## Resultados

El clúster mantuvo disponibles las particiones al detener un broker.

Se comprobó la publicación y lectura de mensajes durante la falla.

Después de reiniciar el broker, las nueve réplicas volvieron a sincronizarse.

## Consideraciones

Este entorno corresponde a un laboratorio local independiente del despliegue de CampusLab en AWS.

Los puertos 19092, 19093 y 19094 no deben estar ocupados por otro clúster Kafka local al iniciar este laboratorio.

## Integración con microservicios

El clúster Kafka se integró con los siguientes microservicios de CampusLab en un entorno de pruebas Docker independiente:

| Microservicio | Puerto local | Función |
|---|---|---|
| MS Bookings | 18081 | Publica eventos de reservas y ocupación |
| MS Audit | 18084 | Consume y registra eventos de auditoría |
| MS Report | 18085 | Consume eventos para generar indicadores |
| MS Kafka Admin | 18086 | Permite consultar y administrar tópicos |

Los servicios se conectan a los tres brokers mediante la red Docker `campuslab-kafka-lab_default`.

### Tópicos principales

- `campuslab.booking.events`: eventos del ciclo de vida de reservas.
- `campuslab.occupancy.events`: eventos de ocupación de recursos.

Ambos tópicos utilizan:

- 3 particiones.
- Factor de replicación 3.
- `min.insync.replicas=2`.
- Retención de 7 días.
- Política de limpieza `delete`.

### Grupos consumidores

- `campuslab-audit-group`: utilizado por MS Audit.
- `campuslab-report-group`: utilizado por MS Report.

## Verificaciones automatizadas mediante scripts

Desde PowerShell, dentro de la carpeta del proyecto, ejecutar:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verificar-kafka.ps1
```

Este script muestra los tópicos disponibles, la configuración de los tópicos principales y los grupos consumidores.

Para revisar los offsets y el retraso de consumo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verificar-consumidores.ps1
```

Ambos scripts requieren Docker Desktop y el clúster Kafka en ejecución. Son comandos de consulta y no modifican mensajes ni tópicos.

## Pruebas de integración realizadas

En el entorno local se comprobó:

1. Publicación de 5 eventos del ciclo de vida de una reserva.
2. Publicación de 2 eventos de ocupación.
3. Consumo de eventos mediante MS Audit y MS Report.
4. Consulta de indicadores en MS Report, con 7 eventos registrados.
5. Verificación de los grupos consumidores, con LAG 0 en las particiones con eventos procesados.
6. Persistencia y recuperación del consumo después del reinicio de servicios.
7. Funcionamiento de Kafka Admin para crear, consultar y eliminar tópicos de demostración.
8. Manejo de tópicos duplicados mediante HTTP 409 Conflict.

Kafka Admin configura `min.insync.replicas=1` para los tópicos de demostración creados con una réplica. Esta configuración no reemplaza el valor 2 utilizado por los tópicos principales.

Las pruebas descritas corresponden al entorno local de la EP5, no a un despliegue productivo.
