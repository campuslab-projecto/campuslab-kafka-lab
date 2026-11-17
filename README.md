
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
