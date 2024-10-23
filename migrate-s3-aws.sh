#!/bin/bash
# ~/.aws/credentials

# [acc1]
# aws_access_key_id = TU_ACCESS_KEY_ACC1
# aws_secret_access_key = TU_SECRET_KEY_ACC1

# [acc2]
# aws_access_key_id = TU_ACCESS_KEY_ACC2
# aws_secret_access_key = TU_SECRET_KEY_ACC2

# Variables
BUCKET_ORIGEN="s3://s3-prod-origin"
BUCKET_DESTINO="s3://production-destine"

# Usar el perfil de acc1 para descargar el contenido del bucket origen
echo "Sincronizando contenido desde acc1 (bucket origen)..."
aws s3 sync $BUCKET_ORIGEN /tmp/migracion --profile acc1

# Subir el contenido al bucket destino en acc2
echo "Subiendo contenido a acc2 (bucket destino)..."
aws s3 sync /tmp/migracion $BUCKET_DESTINO --profile acc2

# Limpiar los archivos temporales
rm -rf /tmp/migracion
echo "Migración completada!"