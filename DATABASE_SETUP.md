# 📦 Guía Completa de Base de Datos SQL Server 2022

**Autor:** José Fernando Rosales Escobar  
**Email:** fernando.rosales.gt@gmail.com  
**Teléfono:** 3302-1642  
**Fecha:** Noviembre 2025  
**Proyecto:** Sistema DICRI Backend - Prueba Técnica

---

## 📋 Tabla de Contenidos

1. [Crear el Contenedor](#1-crear-el-contenedor)
2. [Exportar la Base de Datos](#2-exportar-la-base-de-datos)
3. [Cambiar Puerto del Contenedor](#3-cambiar-puerto-del-contenedor)
4. [Migrar Data a Otro Equipo](#4-migrar-data-a-otro-equipo)
5. [Diagrama Entidad-Relación (ER)](#5-diagrama-entidad-relación-er)
6. [Descripción del Esquema](#6-descripción-del-esquema)
7. [Comandos Útiles](#7-comandos-útiles)

---

## 1. Crear el Contenedor

### 1.1 Archivo `docker-compose.yml`

Crea el siguiente archivo en la raíz del proyecto:

```yaml
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sql_server_2022
    restart: always
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=Pr0ducc10n!
      - MSSQL_PID=Developer
    ports:
      - "1434:1433"
    volumes:
      - sqlserver_data:/var/opt/mssql

volumes:
  sqlserver_data:
```

### 1.2 Variables de Entorno Explicadas

| Variable | Valor | Descripción |
|----------|-------|-------------|
| `ACCEPT_EULA` | `Y` | Acepta los términos de licencia de SQL Server |
| `MSSQL_SA_PASSWORD` | `Pr0ducc10n!` | Contraseña del usuario `sa` (administrador) |
| `MSSQL_PID` | `Developer` | Edición de SQL Server (Developer = gratuita) |

**⚠️ Requisitos de Contraseña:**
- Mínimo 8 caracteres
- Al menos 3 de: mayúsculas, minúsculas, números, símbolos
- Ejemplo válido: `Pr0ducc10n!`, `MyP@ssw0rd`

### 1.3 Levantar el Contenedor

```powershell
# Levantar contenedor en modo detached (background)
docker-compose up -d

# Ver logs en tiempo real
docker-compose logs -f mssql

# Verificar estado del contenedor
docker ps
```

**Salida esperada:**
```
CONTAINER ID   IMAGE                                        STATUS         PORTS
abc123def456   mcr.microsoft.com/mssql/server:2022-latest   Up 30 seconds  0.0.0.0:1434->1433/tcp
```

### 1.4 Crear la Base de Datos

```powershell
# Conectarse al contenedor
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!"

# Crear la base de datos
CREATE DATABASE [dicri-indicios];
GO
USE [dicri-indicios];
GO
EXIT
```

### 1.5 Ejecutar el Schema Completo

```powershell
# Desde PowerShell (Windows)
docker exec -i sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -d dicri-indicios -i /tmp/database-schema.sql

# Si el archivo está en tu equipo, primero cópialo al contenedor
docker cp database-schema.sql sql_server_2022:/tmp/database-schema.sql

# Luego ejecútalo
docker exec -i sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -d dicri-indicios -i /tmp/database-schema.sql
```

### 1.6 Crear Usuario de Aplicación

```powershell
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!"
```

```sql
-- Crear Login
CREATE LOGIN appindicios WITH PASSWORD = 'Ind1c10$';
GO

-- Usar la base de datos
USE [dicri-indicios];
GO

-- Crear usuario en la base de datos
CREATE USER appindicios FOR LOGIN appindicios;
GO

-- Dar permisos completos
ALTER ROLE db_owner ADD MEMBER appindicios;
GO

EXIT
```

**✅ Verificación:**
```powershell
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U appindicios -P "Ind1c10$" -d dicri-indicios -Q "SELECT DB_NAME() AS CurrentDatabase"
```

---

## 2. Exportar la Base de Datos

### 2.1 Backup Completo (.bak)

```powershell
# Crear backup dentro del contenedor
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -Q "BACKUP DATABASE [dicri-indicios] TO DISK = '/var/opt/mssql/backup/dicri-indicios.bak' WITH FORMAT, INIT, NAME = 'Full Backup of dicri-indicios';"

# Copiar backup a tu equipo
docker cp sql_server_2022:/var/opt/mssql/backup/dicri-indicios.bak ./dicri-indicios-backup.bak
```

### 2.2 Exportar Schema + Data (.sql)

```powershell
# Instalar mssql-scripter (una sola vez)
pip install mssql-scripter

# Exportar schema y data
mssql-scripter -S localhost,1434 -U sa -P "Pr0ducc10n!" -d dicri-indicios --include-objects --schema-and-data > dicri-indicios-full-export.sql
```

### 2.3 Exportar Solo Data (CSV)

```powershell
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -d dicri-indicios -Q "SELECT * FROM Usuario" -o usuarios.csv -s "," -W
```

### 2.4 Exportar Volumen Docker

```powershell
# Crear backup del volumen completo
docker run --rm -v sqlserver_data:/data -v ${PWD}:/backup ubuntu tar czf /backup/sqlserver_data_backup.tar.gz -C /data .

# Esto crea: sqlserver_data_backup.tar.gz (incluye todos los archivos de SQL Server)
```

---

## 3. Cambiar Puerto del Contenedor

### 3.1 Modificar `docker-compose.yml`

```yaml
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sql_server_2022
    restart: always
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=Pr0ducc10n!
      - MSSQL_PID=Developer
    ports:
      - "1435:1433"  # ← Puerto cambiado de 1434 a 1435
    volumes:
      - sqlserver_data:/var/opt/mssql

volumes:
  sqlserver_data:
```

### 3.2 Aplicar Cambios

```powershell
# Detener contenedor actual
docker-compose down

# Levantar con nuevo puerto
docker-compose up -d

# Verificar nuevo puerto
docker ps
```

**Nueva cadena de conexión:**
```
Server=localhost,1435;Database=dicri-indicios;User Id=appindicios;Password=Ind1c10$;
```

### 3.3 Actualizar `.env` del Backend

```env
DB_SERVER=localhost,1435  # ← Cambiar puerto aquí también
DB_USER=appindicios
DB_PASSWORD=Ind1c10$
DB_DATABASE=dicri-indicios
```

---

## 4. Migrar Data a Otro Equipo

### 4.1 Método 1: Backup/Restore (.bak) - **RECOMENDADO**

#### En el Equipo Origen:

```powershell
# 1. Crear backup
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -Q "BACKUP DATABASE [dicri-indicios] TO DISK = '/var/opt/mssql/backup/dicri-indicios.bak' WITH FORMAT, INIT;"

# 2. Copiar a tu equipo
docker cp sql_server_2022:/var/opt/mssql/backup/dicri-indicios.bak ./dicri-indicios-backup.bak

# 3. Transferir archivo a otro equipo (USB, red, email, etc.)
```

#### En el Equipo Destino:

```powershell
# 1. Crear contenedor SQL Server (usar mismo docker-compose.yml)
docker-compose up -d

# 2. Copiar backup al contenedor
docker cp dicri-indicios-backup.bak sql_server_2022:/var/opt/mssql/backup/dicri-indicios.bak

# 3. Restaurar base de datos
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -Q "RESTORE DATABASE [dicri-indicios] FROM DISK = '/var/opt/mssql/backup/dicri-indicios.bak' WITH REPLACE;"

# 4. Crear usuario de aplicación (ver sección 1.6)
```

### 4.2 Método 2: Script SQL Completo

#### En el Equipo Origen:

```powershell
# Instalar mssql-scripter
pip install mssql-scripter

# Exportar todo (schema + data)
mssql-scripter -S localhost,1434 -U sa -P "Pr0ducc10n!" -d dicri-indicios --include-objects --schema-and-data > dicri-full-export.sql
```

#### En el Equipo Destino:

```powershell
# 1. Crear contenedor SQL Server
docker-compose up -d

# 2. Copiar script al contenedor
docker cp dicri-full-export.sql sql_server_2022:/tmp/dicri-full-export.sql

# 3. Ejecutar script
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -i /tmp/dicri-full-export.sql
```

### 4.3 Método 3: Volumen Docker (más rápido)

#### En el Equipo Origen:

```powershell
# 1. Detener contenedor
docker-compose down

# 2. Crear backup del volumen
docker run --rm -v sqlserver_data:/data -v ${PWD}:/backup ubuntu tar czf /backup/sqlserver_data.tar.gz -C /data .

# 3. Transferir archivo sqlserver_data.tar.gz a otro equipo
```

#### En el Equipo Destino:

```powershell
# 1. Crear volumen vacío
docker volume create sqlserver_data

# 2. Restaurar datos del volumen
docker run --rm -v sqlserver_data:/data -v ${PWD}:/backup ubuntu tar xzf /backup/sqlserver_data.tar.gz -C /data

# 3. Levantar contenedor (usar mismo docker-compose.yml)
docker-compose up -d
```

---

## 5. Diagrama Entidad-Relación (ER)

### 5.1 Diagrama Visual

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      MÓDULO DE SEGURIDAD                                │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Usuario    │────────>│Usuario_Perfil│<────────│    Perfil    │
│              │ 1     N │              │ N     1 │              │
│ id_usuario   │         │ id_usuario   │         │ id_perfil    │
│ nombre_usuario│        │ id_perfil    │         │nombre_perfil │
│ clave        │         │ fecha_inicio │         │ descripcion  │
│ nombre       │         │ fecha_fin    │         │ activo       │
│ apellido     │         │ activo       │         └──────┬───────┘
│ email        │         └──────────────┘                │
│ activo       │                                         │ 1
│ intentos_fall│                                         │
└──────────────┘                                         │ N
       │                                          ┌──────▼───────┐
       │ 1                                        │Perfil_Modulo │
       │                                          │              │
       │ N                                        │ id_perfil    │
┌──────▼──────────┐                              │ id_modulo    │
│  Investigacion  │                              │ puede_leer   │
│                 │                              │ puede_crear  │
│id_investigacion │                              │puede_editar  │
│ codigo_caso     │                              │puede_eliminar│
│ nombre_caso     │                              └──────┬───────┘
│ fecha_inicio    │                                     │ N
│ id_fiscalia ────┼──────┐                             │
│ estado_revision │      │                             │ 1
│id_usuario_registro    │                      ┌───────▼──────┐
│id_usuario_revision    │                      │    Modulo    │
│justificacion    │      │                      │              │
│ activo          │      │                      │  id_modulo   │
└─────┬───────────┘      │                      │nombre_modulo │
      │ 1                │                      │ descripcion  │
      │                  │                      │ ruta         │
      │ N                │                      │ icono        │
┌─────▼───────┐          │                      │ orden        │
│   Escena    │          │                      │id_modulo_padre│
│             │          │                      └──────────────┘
│  id_escena  │          │
│id_investigacion       │                      ┌──────────────┐
│nombre_escena│          │ 1                N  │     Role     │
│direccion    │          └────────────────────>│              │
│fecha_hora_inicio      │                      │  id_role     │
│fecha_hora_fin│        │                      │ nombre_role  │
│ descripcion  │        │                      │ descripcion  │
│ activo       │        │                      │ activo       │
└─────┬────────┘        │                      └──────┬───────┘
      │ 1               │                             │
      │                 │                             │ N
      │ N               │                      ┌──────▼──────┐
┌─────▼─────┐     ┌─────▼─────┐               │ Role_Modulo │
│  Indicio  │     │ Fiscalia  │               │             │
│           │     │           │               │  id_role    │
│ id_indicio│     │id_fiscalia│               │ id_modulo   │
│ codigo    │     │  nombre   │               │ puede_leer  │
│id_escena  │     │ direccion │               │puede_crear  │
│id_tipo───┐│     │ telefono  │               │puede_editar │
│descripcion││     │ activo    │               │puede_eliminar│
│ubicacion  ││     └───────────┘               └─────────────┘
│fecha_recol││
│id_usuario ││     ┌──────────────┐
│estado_actual      │ TipoIndicio  │
│ activo    ││     │              │
└─────┬─────┘│     │id_tipo_indicio│
      │      └────>│ nombre_tipo  │
      │ 1          │ descripcion  │
      │            │ activo       │
      │ N          └──────────────┘
┌─────▼──────────┐
│CadenaCustodia  │         ┌──────────────┐
│                │         │ EstadoCadena │
│  id_cadena     │         │              │
│  id_indicio    │         │id_estado_cadena│
│id_estado_origen│────────>│nombre_estado │
│id_estado_destino────────>│ descripcion  │
│  fecha_cambio  │         │ activo       │
│id_usuario_responsable    └──────────────┘
│  observaciones │
└────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUJO DE REVISIÓN DICRI                              │
└─────────────────────────────────────────────────────────────────────────┘

         ┌─────────────┐
         │EN_REGISTRO  │ ← Técnico DICRI crea expediente
         └──────┬──────┘
                │ sp_Investigacion_SendToReview
                ▼
         ┌─────────────┐
         │PENDIENTE_   │ ← Coordinador recibe para revisión
         │REVISION     │
         └──────┬──────┘
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
┌──────────┐      ┌──────────┐
│APROBADO  │      │RECHAZADO │
│          │      │          │
│(inmutable)│     │(editable)│
└──────────┘      └─────┬────┘
                        │
                        │ Técnico corrige
                        ▼
                  ┌─────────────┐
                  │EN_REGISTRO  │ ← Vuelve a iniciar flujo
                  └─────────────┘

        sp_Investigacion_Approve    sp_Investigacion_Reject
```

### 5.2 Relaciones Principales

| Tabla Padre | Relación | Tabla Hija | Cardinalidad |
|-------------|----------|------------|--------------|
| **Usuario** | tiene | **Usuario_Perfil** | 1:N |
| **Perfil** | tiene | **Usuario_Perfil** | 1:N |
| **Perfil** | accede a | **Perfil_Modulo** | 1:N |
| **Modulo** | pertenece a | **Perfil_Modulo** | 1:N |
| **Role** | accede a | **Role_Modulo** | 1:N |
| **Perfil** | tiene | **Perfil_Role** | N:M |
| **Fiscalia** | gestiona | **Investigacion** | 1:N |
| **Usuario** | registra | **Investigacion** | 1:N (como técnico) |
| **Usuario** | revisa | **Investigacion** | 1:N (como coordinador) |
| **Investigacion** | contiene | **Escena** | 1:N |
| **Escena** | tiene | **Indicio** | 1:N |
| **TipoIndicio** | clasifica | **Indicio** | 1:N |
| **Indicio** | rastrea | **CadenaCustodia** | 1:N |
| **EstadoCadena** | define | **CadenaCustodia** | 1:N (origen/destino) |

---

## 6. Descripción del Esquema

### 6.1 Módulo de Seguridad

#### **Usuario**
- **Propósito:** Almacena usuarios del sistema con autenticación
- **Campos clave:**
  - `nombre_usuario`: Username único (UK)
  - `clave`: Password hasheada con MD5
  - `email`: Email único (UK)
  - `activo`: Soft delete (1=activo, 0=inactivo)
  - `intentos_fallidos`: Control de intentos de login (máx 3)
  - `cambiar_clave`: Flag para forzar cambio de contraseña

#### **Perfil**
- **Propósito:** Agrupa permisos y roles por tipo de usuario
- **Ejemplos:** Técnico DICRI, Coordinador DICRI, Administrador
- **Relación:** N:M con Usuario a través de `Usuario_Perfil`

#### **Role**
- **Propósito:** Define roles funcionales del sistema
- **Ejemplos:** ADMIN, COORDINADOR_DICRI, TECNICO_DICRI
- **Uso:** JWT incluye roles para autorización en endpoints

#### **Modulo**
- **Propósito:** Representa funcionalidades del sistema (menús)
- **Campos clave:**
  - `ruta`: URL del módulo (`/expedientes`, `/reportes`)
  - `id_modulo_padre`: Para módulos jerárquicos (padre-hijo)
  - `orden`: Orden de visualización en menús

#### **Perfil_Modulo**
- **Propósito:** Define permisos CRUD por perfil y módulo
- **Campos:**
  - `puede_leer`, `puede_crear`, `puede_editar`, `puede_eliminar`
- **Ejemplo:** Técnico DICRI puede leer/crear expedientes pero no eliminar

### 6.2 Módulo de Negocio DICRI

#### **Fiscalia**
- **Propósito:** Catálogo de fiscalías que solicitan análisis
- **Campos:**
  - `nombre_fiscalia`: Nombre único (UK)
  - `direccion`, `telefono`: Datos de contacto

#### **Investigacion (Expediente)**
- **Propósito:** Expediente criminal con flujo de revisión DICRI
- **Campos clave:**
  - `codigo_caso`: Código único del expediente (UK)
  - `estado_revision_dicri`: Estado del flujo
    - `EN_REGISTRO`: Técnico está creando/editando
    - `PENDIENTE_REVISION`: Enviado a coordinador
    - `APROBADO`: Aprobado por coordinador (inmutable)
    - `RECHAZADO`: Rechazado por coordinador (editable)
    - `ELIMINADO`: Soft delete (activo=0)
  - `id_usuario_registro`: Técnico que creó el expediente
  - `id_usuario_revision`: Coordinador que revisó
  - `justificacion_revision`: Razón de aprobación/rechazo

#### **Escena**
- **Propósito:** Lugares físicos donde se recolectaron indicios
- **Relación:** N escenas pertenecen a 1 Investigacion
- **Campos:**
  - `nombre_escena`: Ej. "Escena Principal", "Escena Secundaria"
  - `direccion_escena`: Ubicación física
  - `fecha_hora_inicio/fin`: Periodo de trabajo en la escena

#### **TipoIndicio**
- **Propósito:** Catálogo de tipos de evidencia
- **Ejemplos:** Arma de Fuego, Proyectil, Huella Digital, ADN, Equipo Digital

#### **Indicio**
- **Propósito:** Evidencia física recolectada en una escena
- **Campos clave:**
  - `codigo_indicio`: Código único de rastreo (UK)
  - `id_escena`: Escena donde se recolectó
  - `id_tipo_indicio`: Tipo de evidencia
  - `descripcion_corta`: Descripción breve
  - `ubicacion_especifica`: Ubicación exacta en la escena
  - `fecha_hora_recoleccion`: Timestamp de recolección
  - `id_usuario_recolector`: Técnico que recolectó
  - `estado_actual`: Estado de la cadena de custodia
    - `RECOLECTADO`, `EN_CUSTODIA`, `EN_ANALISIS`, `ANALIZADO`, `DEVUELTO`

#### **EstadoCadena**
- **Propósito:** Catálogo de estados para cadena de custodia
- **Uso:** Define transiciones válidas en `CadenaCustodia`

#### **CadenaCustodia**
- **Propósito:** Rastreo de movimientos de indicios
- **Campos:**
  - `id_estado_origen`: Estado anterior
  - `id_estado_destino`: Estado nuevo
  - `fecha_cambio`: Timestamp del movimiento
  - `id_usuario_responsable`: Usuario que realizó el movimiento
  - `observaciones`: Notas adicionales

### 6.3 Procedimientos Almacenados (SP)

#### **CRUD Genérico**
Cada entidad tiene 5 SPs básicos:
- `sp_[Entidad]_Create`: Insertar nuevo registro
- `sp_[Entidad]_FindById`: Obtener por ID
- `sp_[Entidad]_FindAll`: Listar todos (con filtros)
- `sp_[Entidad]_Update`: Actualizar registro
- `sp_[Entidad]_Delete`: Soft delete (activo=0)

#### **SPs de Flujo DICRI**
```sql
-- Enviar expediente a revisión (Técnico)
sp_Investigacion_SendToReview
  @id_investigacion INT
  @usuario_actualizacion NVARCHAR(50)

-- Aprobar expediente (Coordinador)
sp_Investigacion_Approve
  @id_investigacion INT
  @id_usuario_revision INT
  @justificacion NVARCHAR(MAX)
  @usuario_actualizacion NVARCHAR(50)

-- Rechazar expediente (Coordinador)
sp_Investigacion_Reject
  @id_investigacion INT
  @id_usuario_revision INT
  @justificacion NVARCHAR(MAX)
  @usuario_actualizacion NVARCHAR(50)
```

#### **SPs de Reportes**
```sql
-- Reporte de expedientes en revisión
sp_Reporte_Revision_Expedientes

-- Estadísticas generales (implementado en backend)
GET /api/reportes/estadisticas-generales
```

### 6.4 Auditoría Completa

**Todos** los registros incluyen:
- `usuario_creacion`: Usuario que creó el registro
- `fecha_creacion`: Timestamp de creación (DEFAULT GETDATE())
- `usuario_actualizacion`: Usuario que actualizó por última vez
- `fecha_actualizacion`: Timestamp de última actualización
- `activo`: Flag de soft delete (1=activo, 0=eliminado)

### 6.5 Constraints y Validaciones

#### **Unique Constraints (UK)**
Previenen duplicados:
- `Usuario`: `nombre_usuario`, `email`
- `Perfil`: `nombre_perfil`
- `Role`: `nombre_role`
- `Modulo`: No tiene UK (permite módulos con mismo nombre en distintos niveles)
- `Fiscalia`: `nombre_fiscalia`
- `Investigacion`: `codigo_caso`
- `TipoIndicio`: `nombre_tipo`
- `EstadoCadena`: `nombre_estado`

#### **Foreign Keys (FK)**
Mantienen integridad referencial:
- `Usuario_Perfil`: FK a `Usuario` y `Perfil`
- `Perfil_Modulo`: FK a `Perfil` y `Modulo`
- `Role_Modulo`: FK a `Role` y `Modulo`
- `Investigacion`: FK a `Fiscalia`, `Usuario` (x2 para registro y revisión)
- `Escena`: FK a `Investigacion`
- `Indicio`: FK a `Escena`, `TipoIndicio`, `Usuario` (recolector)
- `CadenaCustodia`: FK a `Indicio`, `EstadoCadena` (x2 para origen y destino), `Usuario` (responsable)

#### **Check Constraints**
No implementados explícitamente, pero validaciones en SPs:
- Password: Mínimo 8 caracteres, complejidad validada en backend
- Email: Formato validado con regex en backend
- Estados: Solo valores permitidos (`EN_REGISTRO`, `PENDIENTE_REVISION`, etc.)

---

## 7. Comandos Útiles

### 7.1 Gestión de Contenedor

```powershell
# Iniciar contenedor
docker start sql_server_2022

# Detener contenedor
docker stop sql_server_2022

# Reiniciar contenedor
docker restart sql_server_2022

# Ver logs
docker logs sql_server_2022 --tail 50 -f

# Eliminar contenedor (conserva volumen)
docker rm sql_server_2022

# Eliminar contenedor y volumen (⚠️ BORRA TODO)
docker-compose down -v
```

### 7.2 Conexión a SQL Server

```powershell
# Desde sqlcmd (dentro del contenedor)
docker exec -it sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!"

# Desde sqlcmd (host Windows)
sqlcmd -S localhost,1434 -U sa -P "Pr0ducc10n!"

# Desde Azure Data Studio
Server: localhost,1434
User: sa
Password: Pr0ducc10n!
Database: dicri-indicios
```

### 7.3 Queries de Diagnóstico

```sql
-- Ver todas las bases de datos
SELECT name, database_id, create_date FROM sys.databases;
GO

-- Ver tamaño de la base de datos
USE [dicri-indicios];
GO
EXEC sp_spaceused;
GO

-- Ver todas las tablas
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
GO

-- Ver usuarios y logins
SELECT name, create_date, is_disabled FROM sys.sql_logins;
GO
SELECT name, create_date FROM sys.database_principals WHERE type = 'S';
GO

-- Ver conteo de registros en todas las tablas
SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
ORDER BY p.rows DESC;
GO

-- Ver procedimientos almacenados
SELECT name, create_date, modify_date FROM sys.procedures ORDER BY name;
GO

-- Ver estado del flujo DICRI
USE [dicri-indicios];
GO
SELECT 
    estado_revision_dicri,
    COUNT(*) AS cantidad
FROM Investigacion
WHERE activo = 1
GROUP BY estado_revision_dicri;
GO
```

### 7.4 Gestión de Volúmenes

```powershell
# Listar volúmenes
docker volume ls

# Inspeccionar volumen
docker volume inspect sqlserver_data

# Backup manual del volumen
docker run --rm -v sqlserver_data:/data -v ${PWD}:/backup ubuntu tar czf /backup/sqlserver_backup_$(Get-Date -Format "yyyyMMdd_HHmmss").tar.gz -C /data .

# Restaurar volumen desde backup
docker run --rm -v sqlserver_data:/data -v ${PWD}:/backup ubuntu tar xzf /backup/sqlserver_backup_20251123_143000.tar.gz -C /data

# Eliminar volumen (⚠️ BORRA DATOS)
docker volume rm sqlserver_data
```

### 7.5 Troubleshooting

```powershell
# Verificar que SQL Server está corriendo
docker exec sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -Q "SELECT @@VERSION"

# Reiniciar SQL Server (desde dentro del contenedor)
docker exec sql_server_2022 /opt/mssql/bin/sqlservr

# Ver procesos de SQL Server
docker exec sql_server_2022 ps aux | grep sqlservr

# Ver uso de recursos del contenedor
docker stats sql_server_2022

# Ver configuración de memoria de SQL Server
docker exec sql_server_2022 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Pr0ducc10n!" -Q "EXEC sp_configure 'max server memory';"
```

---

## 📞 Soporte

**Autor:** José Fernando Rosales Escobar  
**Email:** fernando.rosales.gt@gmail.com  
**Teléfono:** 3302-1642  
**GitHub:** [jfrosalesgt/dicki-backend](https://github.com/jfrosalesgt/dicki-backend)

---

## 📄 Licencia

ISC - Proyecto de Prueba Técnica 2025
