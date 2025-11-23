-- =============================================
-- SCRIPT DE CREACIÓN COMPLETA DE BASE DE DATOS 'dicri-indicios'
-- Fecha: 2025-11-22
-- Descripción: Contiene el esquema completo (DDL) de seguridad y negocio,
-- incluyendo el flujo DICRI, todos los procedimientos almacenados (SP) CRUD,
-- y datos de ejemplo (DML).
-- =============================================

USE [dicri-indicios];
GO

-- =============================================
-- 1. LIMPIEZA DE OBJETOS EXISTENTES (DROP)
-- Asegura que el script se ejecute de manera idempotente.
-- =============================================

-- Desactivar restricciones de clave foránea temporalmente
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";
GO

-- 1.1 Eliminar Procedimientos Almacenados (Todos)
IF OBJECT_ID('sp_Usuario_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_FindById;
IF OBJECT_ID('sp_Usuario_FindByUsername', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_FindByUsername;
IF OBJECT_ID('sp_Usuario_FindByEmail', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_FindByEmail;
IF OBJECT_ID('sp_Usuario_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_Create;
IF OBJECT_ID('sp_Usuario_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_Update;
IF OBJECT_ID('sp_Usuario_UpdatePassword', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_UpdatePassword;
IF OBJECT_ID('sp_Usuario_UpdateLastAccess', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_UpdateLastAccess;
IF OBJECT_ID('sp_Usuario_IncrementFailedAttempts', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_IncrementFailedAttempts;
IF OBJECT_ID('sp_Usuario_ResetFailedAttempts', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_ResetFailedAttempts;
IF OBJECT_ID('sp_Usuario_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Usuario_FindAll;
IF OBJECT_ID('sp_Perfil_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Perfil_FindById;
IF OBJECT_ID('sp_Perfil_FindByName', 'P') IS NOT NULL DROP PROCEDURE sp_Perfil_FindByName;
IF OBJECT_ID('sp_Perfil_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Perfil_Create;
IF OBJECT_ID('sp_Perfil_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Perfil_Update;
IF OBJECT_ID('sp_Perfil_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Perfil_FindAll;
IF OBJECT_ID('sp_Perfil_FindByUsuario', 'P') IS NOT NULL DROP PROCEDURE sp_Perfil_FindByUsuario;
IF OBJECT_ID('sp_Role_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Role_FindById;
IF OBJECT_ID('sp_Role_FindByName', 'P') IS NOT NULL DROP PROCEDURE sp_Role_FindByName;
IF OBJECT_ID('sp_Role_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Role_Create;
IF OBJECT_ID('sp_Role_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Role_Update;
IF OBJECT_ID('sp_Role_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Role_FindAll;
IF OBJECT_ID('sp_Role_FindByUsuario', 'P') IS NOT NULL DROP PROCEDURE sp_Role_FindByUsuario;
IF OBJECT_ID('sp_Modulo_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Modulo_FindById;
IF OBJECT_ID('sp_Modulo_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Modulo_Create;
IF OBJECT_ID('sp_Modulo_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Modulo_Update;
IF OBJECT_ID('sp_Modulo_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Modulo_FindAll;
IF OBJECT_ID('sp_Modulo_FindByPerfil', 'P') IS NOT NULL DROP PROCEDURE sp_Modulo_FindByPerfil;
IF OBJECT_ID('sp_Modulo_FindByUsuario', 'P') IS NOT NULL DROP PROCEDURE sp_Modulo_FindByUsuario;
IF OBJECT_ID('sp_Fiscalia_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Fiscalia_Create;
IF OBJECT_ID('sp_Fiscalia_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Fiscalia_FindAll;
IF OBJECT_ID('sp_Fiscalia_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Fiscalia_FindById;
IF OBJECT_ID('sp_Fiscalia_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Fiscalia_Update;
IF OBJECT_ID('sp_Fiscalia_Delete', 'P') IS NOT NULL DROP PROCEDURE sp_Fiscalia_Delete;
IF OBJECT_ID('sp_Investigacion_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_Create;
IF OBJECT_ID('sp_Investigacion_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_FindAll;
IF OBJECT_ID('sp_Investigacion_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_FindById;
IF OBJECT_ID('sp_Investigacion_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_Update;
IF OBJECT_ID('sp_Investigacion_Delete', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_Delete;
IF OBJECT_ID('sp_Escena_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Escena_Create;
IF OBJECT_ID('sp_Escena_FindByInvestigacion', 'P') IS NOT NULL DROP PROCEDURE sp_Escena_FindByInvestigacion;
IF OBJECT_ID('sp_Escena_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Escena_FindById;
IF OBJECT_ID('sp_Escena_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Escena_Update;
IF OBJECT_ID('sp_Escena_Delete', 'P') IS NOT NULL DROP PROCEDURE sp_Escena_Delete;
IF OBJECT_ID('sp_TipoIndicio_Create', 'P') IS NOT NULL DROP PROCEDURE sp_TipoIndicio_Create;
IF OBJECT_ID('sp_TipoIndicio_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_TipoIndicio_FindAll;
IF OBJECT_ID('sp_TipoIndicio_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_TipoIndicio_FindById;
IF OBJECT_ID('sp_TipoIndicio_Update', 'P') IS NOT NULL DROP PROCEDURE sp_TipoIndicio_Update;
IF OBJECT_ID('sp_TipoIndicio_Delete', 'P') IS NOT NULL DROP PROCEDURE sp_TipoIndicio_Delete;
IF OBJECT_ID('sp_EstadoCadena_Create', 'P') IS NOT NULL DROP PROCEDURE sp_EstadoCadena_Create;
IF OBJECT_ID('sp_EstadoCadena_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_EstadoCadena_FindAll;
IF OBJECT_ID('sp_EstadoCadena_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_EstadoCadena_FindById;
IF OBJECT_ID('sp_EstadoCadena_Update', 'P') IS NOT NULL DROP PROCEDURE sp_EstadoCadena_Update;
IF OBJECT_ID('sp_EstadoCadena_Delete', 'P') IS NOT NULL DROP PROCEDURE sp_EstadoCadena_Delete;
IF OBJECT_ID('sp_Indicio_FindById', 'P') IS NOT NULL DROP PROCEDURE sp_Indicio_FindById;
IF OBJECT_ID('sp_Indicio_Create', 'P') IS NOT NULL DROP PROCEDURE sp_Indicio_Create;
IF OBJECT_ID('sp_Indicio_FindAll', 'P') IS NOT NULL DROP PROCEDURE sp_Indicio_FindAll;
IF OBJECT_ID('sp_Indicio_Update', 'P') IS NOT NULL DROP PROCEDURE sp_Indicio_Update;
IF OBJECT_ID('sp_Indicio_Delete', 'P') IS NOT NULL DROP PROCEDURE sp_Indicio_Delete;
IF OBJECT_ID('sp_CadenaCustodia_Move', 'P') IS NOT NULL DROP PROCEDURE sp_CadenaCustodia_Move;
IF OBJECT_ID('sp_CadenaCustodia_FindByIndicio', 'P') IS NOT NULL DROP PROCEDURE sp_CadenaCustodia_FindByIndicio;
IF OBJECT_ID('sp_Investigacion_SendToReview', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_SendToReview;
IF OBJECT_ID('sp_Investigacion_Approve', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_Approve; 
IF OBJECT_ID('sp_Investigacion_Reject', 'P') IS NOT NULL DROP PROCEDURE sp_Investigacion_Reject; 
IF OBJECT_ID('sp_Reporte_Revision_Expedientes', 'P') IS NOT NULL DROP PROCEDURE sp_Reporte_Revision_Expedientes;
GO

-- 1.2 Eliminar Tablas (Todas)
IF OBJECT_ID('[dbo].[Perfil_Role]', 'U') IS NOT NULL DROP TABLE [dbo].[Perfil_Role];
IF OBJECT_ID('[dbo].[Role_Modulo]', 'U') IS NOT NULL DROP TABLE [dbo].[Role_Modulo];
IF OBJECT_ID('[dbo].[Perfil_Modulo]', 'U') IS NOT NULL DROP TABLE [dbo].[Perfil_Modulo];
IF OBJECT_ID('[dbo].[Usuario_Perfil]', 'U') IS NOT NULL DROP TABLE [dbo].[Usuario_Perfil];
IF OBJECT_ID('[dbo].[CadenaCustodia]', 'U') IS NOT NULL DROP TABLE [dbo].[CadenaCustodia];
IF OBJECT_ID('[dbo].[Indicio]', 'U') IS NOT NULL DROP TABLE [dbo].[Indicio];
IF OBJECT_ID('[dbo].[Escena]', 'U') IS NOT NULL DROP TABLE [dbo].[Escena];
IF OBJECT_ID('[dbo].[Investigacion]', 'U') IS NOT NULL DROP TABLE [dbo].[Investigacion];
IF OBJECT_ID('[dbo].[EstadoRevisionDICRI]', 'U') IS NOT NULL DROP TABLE [dbo].[EstadoRevisionDICRI];
IF OBJECT_ID('[dbo].[EstadoCadena]', 'U') IS NOT NULL DROP TABLE [dbo].[EstadoCadena];
IF OBJECT_ID('[dbo].[TipoIndicio]', 'U') IS NOT NULL DROP TABLE [dbo].[TipoIndicio];
IF OBJECT_ID('[dbo].[Fiscalia]', 'U') IS NOT NULL DROP TABLE [dbo].[Fiscalia];
IF OBJECT_ID('[dbo].[Role]', 'U') IS NOT NULL DROP TABLE [dbo].[Role];
IF OBJECT_ID('[dbo].[Modulo]', 'U') IS NOT NULL DROP TABLE [dbo].[Modulo];
IF OBJECT_ID('[dbo].[Perfil]', 'U') IS NOT NULL DROP TABLE [dbo].[Perfil];
IF OBJECT_ID('[dbo].[Usuario]', 'U') IS NOT NULL DROP TABLE [dbo].[Usuario];
GO

-- Reactivar restricciones (por precaución)
EXEC sp_MSforeachtable "ALTER TABLE ? CHECK CONSTRAINT all";
GO
PRINT 'Objetos eliminados. Comienza la reconstrucción DDL.';
GO

-- =============================================
-- 2. CREACIÓN DE TABLAS (DDL)
-- =============================================

-- Tablas de Seguridad
CREATE TABLE [dbo].[Usuario] (
    [id_usuario] INT IDENTITY(1,1) NOT NULL,
    [nombre_usuario] NVARCHAR(50) NOT NULL,
    [clave] NVARCHAR(255) NOT NULL,
    [nombre] NVARCHAR(100) NOT NULL,
    [apellido] NVARCHAR(100) NOT NULL,
    [email] NVARCHAR(100) NOT NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [cambiar_clave] BIT NOT NULL DEFAULT 0,
    [intentos_fallidos] INT NOT NULL DEFAULT 0,
    [fecha_ultimo_acceso] DATETIME NULL,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED ([id_usuario] ASC),
    CONSTRAINT [UK_Usuario_NombreUsuario] UNIQUE ([nombre_usuario]),
    CONSTRAINT [UK_Usuario_Email] UNIQUE ([email])
);

CREATE TABLE [dbo].[Perfil] (
    [id_perfil] INT IDENTITY(1,1) NOT NULL,
    [nombre_perfil] NVARCHAR(100) NOT NULL,
    [descripcion] NVARCHAR(255) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Perfil] PRIMARY KEY CLUSTERED ([id_perfil] ASC),
    CONSTRAINT [UK_Perfil_Nombre] UNIQUE ([nombre_perfil])
);

CREATE TABLE [dbo].[Modulo] (
    [id_modulo] INT IDENTITY(1,1) NOT NULL,
    [nombre_modulo] NVARCHAR(100) NOT NULL,
    [descripcion] NVARCHAR(255) NULL,
    [ruta] NVARCHAR(255) NULL,
    [icono] NVARCHAR(50) NULL,
    [orden] INT NOT NULL DEFAULT 0,
    [id_modulo_padre] INT NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Modulo] PRIMARY KEY CLUSTERED ([id_modulo] ASC),
    CONSTRAINT [FK_Modulo_ModuloPadre] FOREIGN KEY ([id_modulo_padre]) 
        REFERENCES [dbo].[Modulo]([id_modulo])
);

CREATE TABLE [dbo].[Role] (
    [id_role] INT IDENTITY(1,1) NOT NULL,
    [nombre_role] NVARCHAR(100) NOT NULL,
    [descripcion] NVARCHAR(255) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([id_role] ASC),
    CONSTRAINT [UK_Role_Nombre] UNIQUE ([nombre_role])
);

-- Tablas de Relación N:M de Seguridad
CREATE TABLE [dbo].[Usuario_Perfil] (
    [id_usuario_perfil] INT IDENTITY(1,1) NOT NULL,
    [id_usuario] INT NOT NULL,
    [id_perfil] INT NOT NULL,
    [fecha_inicio] DATETIME NOT NULL DEFAULT GETDATE(),
    [fecha_fin] DATETIME NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Usuario_Perfil] PRIMARY KEY CLUSTERED ([id_usuario_perfil] ASC),
    CONSTRAINT [FK_Usuario_Perfil_Usuario] FOREIGN KEY ([id_usuario]) 
        REFERENCES [dbo].[Usuario]([id_usuario]),
    CONSTRAINT [FK_Usuario_Perfil_Perfil] FOREIGN KEY ([id_perfil]) 
        REFERENCES [dbo].[Perfil]([id_perfil]),
    CONSTRAINT [UK_Usuario_Perfil] UNIQUE ([id_usuario], [id_perfil])
);

CREATE TABLE [dbo].[Perfil_Modulo] (
    [id_perfil_modulo] INT IDENTITY(1,1) NOT NULL,
    [id_perfil] INT NOT NULL,
    [id_modulo] INT NOT NULL,
    [puede_leer] BIT NOT NULL DEFAULT 1,
    [puede_crear] BIT NOT NULL DEFAULT 0,
    [puede_editar] BIT NOT NULL DEFAULT 0,
    [puede_eliminar] BIT NOT NULL DEFAULT 0,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Perfil_Modulo] PRIMARY KEY CLUSTERED ([id_perfil_modulo] ASC),
    CONSTRAINT [FK_Perfil_Modulo_Perfil] FOREIGN KEY ([id_perfil]) 
        REFERENCES [dbo].[Perfil]([id_perfil]),
    CONSTRAINT [FK_Perfil_Modulo_Modulo] FOREIGN KEY ([id_modulo]) 
        REFERENCES [dbo].[Modulo]([id_modulo]),
    CONSTRAINT [UK_Perfil_Modulo] UNIQUE ([id_perfil], [id_modulo])
);

CREATE TABLE [dbo].[Role_Modulo] (
    [id_role_modulo] INT IDENTITY(1,1) NOT NULL,
    [id_role] INT NOT NULL,
    [id_modulo] INT NOT NULL,
    [puede_leer] BIT NOT NULL DEFAULT 1,
    [puede_crear] BIT NOT NULL DEFAULT 0,
    [puede_editar] BIT NOT NULL DEFAULT 0,
    [puede_eliminar] BIT NOT NULL DEFAULT 0,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Role_Modulo] PRIMARY KEY CLUSTERED ([id_role_modulo] ASC),
    CONSTRAINT [FK_Role_Modulo_Role] FOREIGN KEY ([id_role]) 
        REFERENCES [dbo].[Role]([id_role]),
    CONSTRAINT [FK_Role_Modulo_Modulo] FOREIGN KEY ([id_modulo]) 
        REFERENCES [dbo].[Modulo]([id_modulo]),
    CONSTRAINT [UK_Role_Modulo] UNIQUE ([id_role], [id_modulo])
);

CREATE TABLE [dbo].[Perfil_Role] (
    [id_perfil_role] INT IDENTITY(1,1) NOT NULL,
    [id_perfil] INT NOT NULL,
    [id_role] INT NOT NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Perfil_Role] PRIMARY KEY CLUSTERED ([id_perfil_role] ASC),
    CONSTRAINT [FK_Perfil_Role_Perfil] FOREIGN KEY ([id_perfil]) 
        REFERENCES [dbo].[Perfil]([id_perfil]),
    CONSTRAINT [FK_Perfil_Role_Role] FOREIGN KEY ([id_role]) 
        REFERENCES [dbo].[Role]([id_role]),
    CONSTRAINT [UK_Perfil_Role] UNIQUE ([id_perfil], [id_role])
);

-- Tablas de Catálogo DICRI
CREATE TABLE [dbo].[Fiscalia] (
    [id_fiscalia] INT IDENTITY(1,1) NOT NULL,
    [nombre_fiscalia] NVARCHAR(150) NOT NULL,
    [direccion] NVARCHAR(255) NULL,
    [telefono] NVARCHAR(20) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Fiscalia] PRIMARY KEY CLUSTERED ([id_fiscalia] ASC),
    CONSTRAINT [UK_Fiscalia_Nombre] UNIQUE ([nombre_fiscalia])
);

CREATE TABLE [dbo].[TipoIndicio] (
    [id_tipo_indicio] INT IDENTITY(1,1) NOT NULL,
    [nombre_tipo] NVARCHAR(100) NOT NULL,
    [descripcion] NVARCHAR(255) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_TipoIndicio] PRIMARY KEY CLUSTERED ([id_tipo_indicio] ASC),
    CONSTRAINT [UK_TipoIndicio_Nombre] UNIQUE ([nombre_tipo])
);

CREATE TABLE [dbo].[EstadoCadena] (
    [id_estado_cadena] INT IDENTITY(1,1) NOT NULL,
    [nombre_estado] NVARCHAR(100) NOT NULL,
    [descripcion] NVARCHAR(255) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_EstadoCadena] PRIMARY KEY CLUSTERED ([id_estado_cadena] ASC),
    CONSTRAINT [UK_EstadoCadena_Nombre] UNIQUE ([nombre_estado])
);

-- Tabla de Control de Flujo DICRI
CREATE TABLE [dbo].[EstadoRevisionDICRI] (
    [id_estado] INT IDENTITY(1,1) NOT NULL,
    [nombre_estado] NVARCHAR(50) NOT NULL, 
    [descripcion] NVARCHAR(255) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_EstadoRevisionDICRI] PRIMARY KEY CLUSTERED ([id_estado] ASC),
    CONSTRAINT [UK_EstadoRevisionDICRI_Nombre] UNIQUE ([nombre_estado])
);

-- Tabla de Expediente (Investigacion) con campos de Flujo
CREATE TABLE [dbo].[Investigacion] (
    [id_investigacion] INT IDENTITY(1,1) NOT NULL,
    [codigo_caso] NVARCHAR(50) NOT NULL,
    [nombre_caso] NVARCHAR(255) NOT NULL,
    [fecha_inicio] DATE NOT NULL,
    [id_fiscalia] INT NOT NULL,
    [descripcion_hechos] NVARCHAR(MAX) NULL,
    [estado_revision_dicri] NVARCHAR(50) NOT NULL DEFAULT 'EN_REGISTRO',
    [id_usuario_registro] INT NOT NULL, 
    [id_usuario_revision] INT NULL,      
    [justificacion_revision] NVARCHAR(MAX) NULL,
    [fecha_revision] DATETIME NULL,      
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Investigacion] PRIMARY KEY CLUSTERED ([id_investigacion] ASC),
    CONSTRAINT [UK_Investigacion_Codigo] UNIQUE ([codigo_caso]),
    CONSTRAINT [FK_Investigacion_Fiscalia] FOREIGN KEY ([id_fiscalia]) 
        REFERENCES [dbo].[Fiscalia]([id_fiscalia]),
    CONSTRAINT [FK_Investigacion_UsuarioRegistro] FOREIGN KEY ([id_usuario_registro]) 
        REFERENCES [dbo].[Usuario]([id_usuario]),
    CONSTRAINT [FK_Investigacion_UsuarioRevision] FOREIGN KEY ([id_usuario_revision]) 
        REFERENCES [dbo].[Usuario]([id_usuario])
);

-- Tabla de Escena
CREATE TABLE [dbo].[Escena] (
    [id_escena] INT IDENTITY(1,1) NOT NULL,
    [id_investigacion] INT NOT NULL,
    [nombre_escena] NVARCHAR(150) NOT NULL,
    [direccion_escena] NVARCHAR(255) NOT NULL,
    [fecha_hora_inicio] DATETIME NOT NULL,
    [fecha_hora_fin] DATETIME NULL,
    [descripcion] NVARCHAR(MAX) NULL,
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Escena] PRIMARY KEY CLUSTERED ([id_escena] ASC),
    CONSTRAINT [FK_Escena_Investigacion] FOREIGN KEY ([id_investigacion]) 
        REFERENCES [dbo].[Investigacion]([id_investigacion])
);

-- Tabla de Indicio
CREATE TABLE [dbo].[Indicio] (
    [id_indicio] INT IDENTITY(1,1) NOT NULL,
    [codigo_indicio] NVARCHAR(50) NOT NULL,
    [id_escena] INT NOT NULL,
    [id_tipo_indicio] INT NOT NULL,
    [descripcion_corta] NVARCHAR(255) NOT NULL,
    [ubicacion_especifica] NVARCHAR(100) NULL,
    [fecha_hora_recoleccion] DATETIME NOT NULL,
    [id_usuario_recolector] INT NOT NULL,
    [estado_actual] NVARCHAR(50) NOT NULL DEFAULT 'RECOLECTADO',
    [activo] BIT NOT NULL DEFAULT 1,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    [usuario_actualizacion] NVARCHAR(50) NULL,
    [fecha_actualizacion] DATETIME NULL,
    CONSTRAINT [PK_Indicio] PRIMARY KEY CLUSTERED ([id_indicio] ASC),
    CONSTRAINT [UK_Indicio_Codigo] UNIQUE ([codigo_indicio]),
    CONSTRAINT [FK_Indicio_Escena] FOREIGN KEY ([id_escena]) 
        REFERENCES [dbo].[Escena]([id_escena]),
    CONSTRAINT [FK_Indicio_TipoIndicio] FOREIGN KEY ([id_tipo_indicio]) 
        REFERENCES [dbo].[TipoIndicio]([id_tipo_indicio]),
    CONSTRAINT [FK_Indicio_UsuarioRecolector] FOREIGN KEY ([id_usuario_recolector]) 
        REFERENCES [dbo].[Usuario]([id_usuario])
);

-- Tabla de Cadena de Custodia
CREATE TABLE [dbo].[CadenaCustodia] (
    [id_cadena_custodia] BIGINT IDENTITY(1,1) NOT NULL,
    [id_indicio] INT NOT NULL,
    [id_estado_cadena] INT NOT NULL,
    [fecha_movimiento] DATETIME NOT NULL DEFAULT GETDATE(),
    [id_usuario_responsable] INT NOT NULL,
    [observaciones] NVARCHAR(MAX) NULL,
    [documento_referencia] NVARCHAR(100) NULL,
    [usuario_creacion] NVARCHAR(50) NOT NULL,
    [fecha_creacion] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_CadenaCustodia] PRIMARY KEY CLUSTERED ([id_cadena_custodia] ASC),
    CONSTRAINT [FK_CadenaCustodia_Indicio] FOREIGN KEY ([id_indicio]) 
        REFERENCES [dbo].[Indicio]([id_indicio]),
    CONSTRAINT [FK_CadenaCustodia_Estado] FOREIGN KEY ([id_estado_cadena]) 
        REFERENCES [dbo].[EstadoCadena]([id_estado_cadena]),
    CONSTRAINT [FK_CadenaCustodia_Usuario] FOREIGN KEY ([id_usuario_responsable]) 
        REFERENCES [dbo].[Usuario]([id_usuario])
);
GO

-- 2.1 Creación de Índices
CREATE NONCLUSTERED INDEX [IX_Usuario_Email] ON [dbo].[Usuario] ([email]);
CREATE NONCLUSTERED INDEX [IX_Usuario_Activo] ON [dbo].[Usuario] ([activo]);
CREATE NONCLUSTERED INDEX [IX_Perfil_Activo] ON [dbo].[Perfil] ([activo]);
CREATE NONCLUSTERED INDEX [IX_Modulo_Activo] ON [dbo].[Modulo] ([activo]);
CREATE NONCLUSTERED INDEX [IX_Modulo_Padre] ON [dbo].[Modulo] ([id_modulo_padre]);
CREATE NONCLUSTERED INDEX [IX_Role_Activo] ON [dbo].[Role] ([activo]);
CREATE NONCLUSTERED INDEX [IX_Usuario_Perfil_Usuario] ON [dbo].[Usuario_Perfil] ([id_usuario]);
CREATE NONCLUSTERED INDEX [IX_Usuario_Perfil_Perfil] ON [dbo].[Usuario_Perfil] ([id_perfil]);
CREATE NONCLUSTERED INDEX [IX_Perfil_Modulo_Perfil] ON [dbo].[Perfil_Modulo] ([id_perfil]);
CREATE NONCLUSTERED INDEX [IX_Perfil_Modulo_Modulo] ON [dbo].[Perfil_Modulo] ([id_modulo]);
CREATE NONCLUSTERED INDEX [IX_Investigacion_Fiscalia] ON [dbo].[Investigacion] ([id_fiscalia]);
CREATE NONCLUSTERED INDEX [IX_Escena_Investigacion] ON [dbo].[Escena] ([id_investigacion]);
CREATE NONCLUSTERED INDEX [IX_Indicio_Escena] ON [dbo].[Indicio] ([id_escena]);
CREATE NONCLUSTERED INDEX [IX_Indicio_Tipo] ON [dbo].[Indicio] ([id_tipo_indicio]);
CREATE NONCLUSTERED INDEX [IX_Indicio_Recolector] ON [dbo].[Indicio] ([id_usuario_recolector]);
CREATE NONCLUSTERED INDEX [IX_CadenaCustodia_Indicio] ON [dbo].[CadenaCustodia] ([id_indicio]);
GO
PRINT 'Estructura de tablas e índices recreada exitosamente.';
GO

-- =============================================
-- 3. CREACIÓN DE PROCEDIMIENTOS ALMACENADOS (SPs)
-- =============================================

-- SPs de Usuario (Seguridad)
CREATE PROCEDURE sp_Usuario_FindById @id_usuario INT AS BEGIN SET NOCOUNT ON; SELECT * FROM Usuario WHERE id_usuario = @id_usuario; END
GO
CREATE PROCEDURE sp_Usuario_FindByUsername @nombre_usuario NVARCHAR(50) AS BEGIN SET NOCOUNT ON; SELECT * FROM Usuario WHERE nombre_usuario = @nombre_usuario; END
GO
CREATE PROCEDURE sp_Usuario_FindByEmail @email NVARCHAR(100) AS BEGIN SET NOCOUNT ON; SELECT * FROM Usuario WHERE email = @email; END
GO
CREATE PROCEDURE sp_Usuario_Create @nombre_usuario NVARCHAR(50), @clave NVARCHAR(255), @nombre NVARCHAR(100), @apellido NVARCHAR(100), @email NVARCHAR(100), @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Usuario (nombre_usuario, clave, nombre, apellido, email, usuario_creacion) VALUES (@nombre_usuario, @clave, @nombre, @apellido, @email, @usuario_creacion); SELECT * FROM Usuario WHERE id_usuario = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Usuario_Update @id_usuario INT, @nombre NVARCHAR(100) = NULL, @apellido NVARCHAR(100) = NULL, @email NVARCHAR(100) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Usuario SET nombre = ISNULL(@nombre, nombre), apellido = ISNULL(@apellido, apellido), email = ISNULL(@email, email), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_usuario = @id_usuario; END
GO
CREATE PROCEDURE sp_Usuario_UpdatePassword @id_usuario INT, @clave NVARCHAR(255), @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Usuario SET clave = @clave, cambiar_clave = 0, intentos_fallidos = 0, usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_usuario = @id_usuario; END
GO
CREATE PROCEDURE sp_Usuario_UpdateLastAccess @id_usuario INT AS BEGIN SET NOCOUNT ON; UPDATE Usuario SET fecha_ultimo_acceso = GETDATE() WHERE id_usuario = @id_usuario; END
GO
CREATE PROCEDURE sp_Usuario_IncrementFailedAttempts @id_usuario INT AS BEGIN SET NOCOUNT ON; UPDATE Usuario SET intentos_fallidos = intentos_fallidos + 1 WHERE id_usuario = @id_usuario; END
GO
CREATE PROCEDURE sp_Usuario_ResetFailedAttempts @id_usuario INT AS BEGIN SET NOCOUNT ON; UPDATE Usuario SET intentos_fallidos = 0 WHERE id_usuario = @id_usuario; END
GO
CREATE PROCEDURE sp_Usuario_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM Usuario; ELSE SELECT * FROM Usuario WHERE activo = @activo; END
GO

-- SPs de Perfil (Seguridad)
CREATE PROCEDURE sp_Perfil_FindById @id_perfil INT AS BEGIN SET NOCOUNT ON; SELECT * FROM Perfil WHERE id_perfil = @id_perfil; END
GO
CREATE PROCEDURE sp_Perfil_FindByName @nombre_perfil NVARCHAR(100) AS BEGIN SET NOCOUNT ON; SELECT * FROM Perfil WHERE nombre_perfil = @nombre_perfil; END
GO
CREATE PROCEDURE sp_Perfil_Create @nombre_perfil NVARCHAR(100), @descripcion NVARCHAR(255) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Perfil (nombre_perfil, descripcion, usuario_creacion) VALUES (@nombre_perfil, @descripcion, @usuario_creacion); SELECT * FROM Perfil WHERE id_perfil = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Perfil_Update @id_perfil INT, @nombre_perfil NVARCHAR(100) = NULL, @descripcion NVARCHAR(255) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Perfil SET nombre_perfil = ISNULL(@nombre_perfil, nombre_perfil), descripcion = ISNULL(@descripcion, descripcion), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_perfil = @id_perfil; END
GO
CREATE PROCEDURE sp_Perfil_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM Perfil; ELSE SELECT * FROM Perfil WHERE activo = @activo; END
GO
CREATE PROCEDURE sp_Perfil_FindByUsuario @id_usuario INT AS BEGIN SET NOCOUNT ON; SELECT p.* FROM Perfil p INNER JOIN Usuario_Perfil up ON p.id_perfil = up.id_perfil WHERE up.id_usuario = @id_usuario AND p.activo = 1 AND up.activo = 1 AND (up.fecha_fin IS NULL OR up.fecha_fin > GETDATE()); END
GO

-- SPs de Role (Seguridad)
CREATE PROCEDURE sp_Role_FindById @id_role INT AS BEGIN SET NOCOUNT ON; SELECT * FROM Role WHERE id_role = @id_role; END
GO
CREATE PROCEDURE sp_Role_FindByName @nombre_role NVARCHAR(100) AS BEGIN SET NOCOUNT ON; SELECT * FROM Role WHERE nombre_role = @nombre_role; END
GO
CREATE PROCEDURE sp_Role_Create @nombre_role NVARCHAR(100), @descripcion NVARCHAR(255) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Role (nombre_role, descripcion, usuario_creacion) VALUES (@nombre_role, @descripcion, @usuario_creacion); SELECT * FROM Role WHERE id_role = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Role_Update @id_role INT, @nombre_role NVARCHAR(100) = NULL, @descripcion NVARCHAR(255) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Role SET nombre_role = ISNULL(@nombre_role, nombre_role), descripcion = ISNULL(@descripcion, descripcion), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_role = @id_role; END
GO
CREATE PROCEDURE sp_Role_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM Role; ELSE SELECT * FROM Role WHERE activo = @activo; END
GO
CREATE PROCEDURE sp_Role_FindByUsuario @id_usuario INT AS BEGIN SET NOCOUNT ON; SELECT DISTINCT r.* FROM Role r INNER JOIN Perfil_Role pr ON r.id_role = pr.id_role INNER JOIN Usuario_Perfil up ON pr.id_perfil = up.id_perfil WHERE up.id_usuario = @id_usuario AND r.activo = 1 AND pr.activo = 1 AND up.activo = 1 AND (up.fecha_fin IS NULL OR up.fecha_fin > GETDATE()); END
GO

-- SPs de Modulo (Seguridad)
CREATE PROCEDURE sp_Modulo_FindById @id_modulo INT AS BEGIN SET NOCOUNT ON; SELECT * FROM Modulo WHERE id_modulo = @id_modulo; END
GO
CREATE PROCEDURE sp_Modulo_Create @nombre_modulo NVARCHAR(100), @descripcion NVARCHAR(255) = NULL, @ruta NVARCHAR(255) = NULL, @icono NVARCHAR(50) = NULL, @orden INT = 0, @id_modulo_padre INT = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Modulo (nombre_modulo, descripcion, ruta, icono, orden, id_modulo_padre, usuario_creacion) VALUES (@nombre_modulo, @descripcion, @ruta, @icono, @orden, @id_modulo_padre, @usuario_creacion); SELECT * FROM Modulo WHERE id_modulo = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Modulo_Update @id_modulo INT, @nombre_modulo NVARCHAR(100) = NULL, @descripcion NVARCHAR(255) = NULL, @ruta NVARCHAR(255) = NULL, @icono NVARCHAR(50) = NULL, @orden INT = NULL, @id_modulo_padre INT = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Modulo SET nombre_modulo = ISNULL(@nombre_modulo, nombre_modulo), descripcion = ISNULL(@descripcion, descripcion), ruta = ISNULL(@ruta, ruta), icono = ISNULL(@icono, icono), orden = ISNULL(@orden, orden), id_modulo_padre = ISNULL(@id_modulo_padre, id_modulo_padre), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_modulo = @id_modulo; END
GO
CREATE PROCEDURE sp_Modulo_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM Modulo ORDER BY orden, nombre_modulo; ELSE SELECT * FROM Modulo WHERE activo = @activo ORDER BY orden, nombre_modulo; END
GO
CREATE PROCEDURE sp_Modulo_FindByPerfil @id_perfil INT AS BEGIN SET NOCOUNT ON; SELECT DISTINCT m.* FROM Modulo m INNER JOIN Perfil_Modulo pm ON m.id_modulo = pm.id_modulo WHERE pm.id_perfil = @id_perfil AND m.activo = 1 AND pm.activo = 1 ORDER BY m.orden, m.nombre_modulo; END
GO
CREATE PROCEDURE sp_Modulo_FindByUsuario @id_usuario INT AS BEGIN SET NOCOUNT ON; SELECT DISTINCT m.* FROM Modulo m INNER JOIN Perfil_Modulo pm ON m.id_modulo = pm.id_modulo INNER JOIN Usuario_Perfil up ON pm.id_perfil = up.id_perfil WHERE up.id_usuario = @id_usuario AND m.activo = 1 AND pm.activo = 1 AND up.activo = 1 AND (up.fecha_fin IS NULL OR up.fecha_fin > GETDATE()) ORDER BY m.orden, m.nombre_modulo; END
GO

-- SPs de Catálogos (Fiscalia, TipoIndicio, EstadoCadena)
CREATE PROCEDURE sp_Fiscalia_Create @nombre_fiscalia NVARCHAR(150), @direccion NVARCHAR(255) = NULL, @telefono NVARCHAR(20) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Fiscalia (nombre_fiscalia, direccion, telefono, usuario_creacion) VALUES (@nombre_fiscalia, @direccion, @telefono, @usuario_creacion); SELECT * FROM Fiscalia WHERE id_fiscalia = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Fiscalia_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM Fiscalia ORDER BY nombre_fiscalia; ELSE SELECT * FROM Fiscalia WHERE activo = @activo ORDER BY nombre_fiscalia; END
GO
CREATE PROCEDURE sp_Fiscalia_FindById @id_fiscalia INT AS BEGIN SET NOCOUNT ON; SELECT * FROM Fiscalia WHERE id_fiscalia = @id_fiscalia; END
GO
CREATE PROCEDURE sp_Fiscalia_Update @id_fiscalia INT, @nombre_fiscalia NVARCHAR(150) = NULL, @direccion NVARCHAR(255) = NULL, @telefono NVARCHAR(20) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Fiscalia SET nombre_fiscalia = ISNULL(@nombre_fiscalia, nombre_fiscalia), direccion = ISNULL(@direccion, direccion), telefono = ISNULL(@telefono, telefono), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_fiscalia = @id_fiscalia; END
GO
CREATE PROCEDURE sp_Fiscalia_Delete @id_fiscalia INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Fiscalia SET activo = 0, usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_fiscalia = @id_fiscalia; END
GO
CREATE PROCEDURE sp_TipoIndicio_Create @nombre_tipo NVARCHAR(100), @descripcion NVARCHAR(255) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO TipoIndicio (nombre_tipo, descripcion, usuario_creacion) VALUES (@nombre_tipo, @descripcion, @usuario_creacion); SELECT * FROM TipoIndicio WHERE id_tipo_indicio = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_TipoIndicio_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM TipoIndicio ORDER BY nombre_tipo; ELSE SELECT * FROM TipoIndicio WHERE activo = @activo ORDER BY nombre_tipo; END
GO
CREATE PROCEDURE sp_TipoIndicio_FindById @id_tipo_indicio INT AS BEGIN SET NOCOUNT ON; SELECT * FROM TipoIndicio WHERE id_tipo_indicio = @id_tipo_indicio; END
GO
CREATE PROCEDURE sp_TipoIndicio_Update @id_tipo_indicio INT, @nombre_tipo NVARCHAR(100) = NULL, @descripcion NVARCHAR(255) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE TipoIndicio SET nombre_tipo = ISNULL(@nombre_tipo, nombre_tipo), descripcion = ISNULL(@descripcion, descripcion), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_tipo_indicio = @id_tipo_indicio; END
GO
CREATE PROCEDURE sp_TipoIndicio_Delete @id_tipo_indicio INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE TipoIndicio SET activo = 0, usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_tipo_indicio = @id_tipo_indicio; END
GO
CREATE PROCEDURE sp_EstadoCadena_Create @nombre_estado NVARCHAR(100), @descripcion NVARCHAR(255) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO EstadoCadena (nombre_estado, descripcion, usuario_creacion) VALUES (@nombre_estado, @descripcion, @usuario_creacion); SELECT * FROM EstadoCadena WHERE id_estado_cadena = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_EstadoCadena_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; IF @activo IS NULL SELECT * FROM EstadoCadena ORDER BY nombre_estado; ELSE SELECT * FROM EstadoCadena WHERE activo = @activo ORDER BY nombre_estado; END
GO
CREATE PROCEDURE sp_EstadoCadena_FindById @id_estado_cadena INT AS BEGIN SET NOCOUNT ON; SELECT * FROM EstadoCadena WHERE id_estado_cadena = @id_estado_cadena; END
GO
CREATE PROCEDURE sp_EstadoCadena_Update @id_estado_cadena INT, @nombre_estado NVARCHAR(100) = NULL, @descripcion NVARCHAR(255) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE EstadoCadena SET nombre_estado = ISNULL(@nombre_estado, nombre_estado), descripcion = ISNULL(@descripcion, descripcion), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_estado_cadena = @id_estado_cadena; END
GO
CREATE PROCEDURE sp_EstadoCadena_Delete @id_estado_cadena INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE EstadoCadena SET activo = 0, usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_estado_cadena = @id_estado_cadena; END
GO

-- SPs de Negocio (Investigacion, Escena, Indicio, CadenaCustodia)
CREATE PROCEDURE sp_Investigacion_Create @codigo_caso NVARCHAR(50), @nombre_caso NVARCHAR(255), @fecha_inicio DATE, @id_fiscalia INT, @id_usuario_registro INT, @descripcion_hechos NVARCHAR(MAX) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Investigacion (codigo_caso, nombre_caso, fecha_inicio, id_fiscalia, descripcion_hechos, id_usuario_registro, usuario_creacion) VALUES (@codigo_caso, @nombre_caso, @fecha_inicio, @id_fiscalia, @descripcion_hechos, @id_usuario_registro, @usuario_creacion); SELECT * FROM Investigacion WHERE id_investigacion = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Investigacion_FindAll @activo BIT = NULL AS BEGIN SET NOCOUNT ON; SELECT i.*, f.nombre_fiscalia FROM Investigacion i INNER JOIN Fiscalia f ON i.id_fiscalia = f.id_fiscalia WHERE i.activo = ISNULL(@activo, i.activo) ORDER BY i.fecha_creacion DESC; END
GO
CREATE PROCEDURE sp_Investigacion_FindById @id_investigacion INT AS BEGIN SET NOCOUNT ON; SELECT i.*, f.nombre_fiscalia FROM Investigacion i INNER JOIN Fiscalia f ON i.id_fiscalia = f.id_fiscalia WHERE i.id_investigacion = @id_investigacion; END
GO
CREATE PROCEDURE sp_Investigacion_Update @id_investigacion INT, @nombre_caso NVARCHAR(255) = NULL, @fecha_inicio DATE = NULL, @id_fiscalia INT = NULL, @descripcion_hechos NVARCHAR(MAX) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Investigacion SET nombre_caso = ISNULL(@nombre_caso, nombre_caso), fecha_inicio = ISNULL(@fecha_inicio, fecha_inicio), id_fiscalia = ISNULL(@id_fiscalia, id_fiscalia), descripcion_hechos = ISNULL(@descripcion_hechos, descripcion_hechos), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_investigacion = @id_investigacion; END
GO
CREATE PROCEDURE sp_Investigacion_Delete @id_investigacion INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Investigacion SET activo = 0, estado_revision_dicri = 'ELIMINADO', usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_investigacion = @id_investigacion; END
GO
CREATE PROCEDURE sp_Escena_Create @id_investigacion INT, @nombre_escena NVARCHAR(150), @direccion_escena NVARCHAR(255), @fecha_hora_inicio DATETIME, @fecha_hora_fin DATETIME = NULL, @descripcion NVARCHAR(MAX) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; INSERT INTO Escena (id_investigacion, nombre_escena, direccion_escena, fecha_hora_inicio, fecha_hora_fin, descripcion, usuario_creacion) VALUES (@id_investigacion, @nombre_escena, @direccion_escena, @fecha_hora_inicio, @fecha_hora_fin, @descripcion, @usuario_creacion); SELECT * FROM Escena WHERE id_escena = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_Escena_FindByInvestigacion @id_investigacion INT, @activo BIT = NULL AS BEGIN SET NOCOUNT ON; SELECT * FROM Escena WHERE id_investigacion = @id_investigacion AND activo = ISNULL(@activo, activo) ORDER BY fecha_hora_inicio DESC; END
GO
CREATE PROCEDURE sp_Escena_FindById @id_escena INT AS BEGIN SET NOCOUNT ON; SELECT * FROM Escena WHERE id_escena = @id_escena; END
GO
CREATE PROCEDURE sp_Escena_Update @id_escena INT, @nombre_escena NVARCHAR(150) = NULL, @direccion_escena NVARCHAR(255) = NULL, @fecha_hora_inicio DATETIME = NULL, @fecha_hora_fin DATETIME = NULL, @descripcion NVARCHAR(MAX) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Escena SET nombre_escena = ISNULL(@nombre_escena, nombre_escena), direccion_escena = ISNULL(@direccion_escena, direccion_escena), fecha_hora_inicio = ISNULL(@fecha_hora_inicio, fecha_hora_inicio), fecha_hora_fin = @fecha_hora_fin, descripcion = ISNULL(@descripcion, descripcion), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_escena = @id_escena; END
GO
CREATE PROCEDURE sp_Escena_Delete @id_escena INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Escena SET activo = 0, usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_escena = @id_escena; END
GO
CREATE PROCEDURE sp_Indicio_FindById @id_indicio INT AS BEGIN SET NOCOUNT ON; SELECT i.id_indicio, i.codigo_indicio, i.id_escena, i.id_tipo_indicio, i.descripcion_corta, i.ubicacion_especifica, i.fecha_hora_recoleccion, i.estado_actual, i.activo, t.nombre_tipo AS tipo_indicio, e.nombre_escena, e.direccion_escena, inv.codigo_caso, inv.nombre_caso, f.nombre_fiscalia, u_rec.nombre AS recolector_nombre, u_rec.apellido AS recolector_apellido FROM Indicio i INNER JOIN TipoIndicio t ON i.id_tipo_indicio = t.id_tipo_indicio INNER JOIN Escena e ON i.id_escena = e.id_escena INNER JOIN Investigacion inv ON e.id_investigacion = inv.id_investigacion INNER JOIN Fiscalia f ON inv.id_fiscalia = f.id_fiscalia INNER JOIN Usuario u_rec ON i.id_usuario_recolector = u_rec.id_usuario WHERE i.id_indicio = @id_indicio; END
GO
CREATE PROCEDURE sp_Indicio_Create @codigo_indicio NVARCHAR(50), @id_escena INT, @id_tipo_indicio INT, @descripcion_corta NVARCHAR(255), @ubicacion_especifica NVARCHAR(100) = NULL, @fecha_hora_recoleccion DATETIME, @id_usuario_recolector INT, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; DECLARE @id_indicio INT; DECLARE @id_estado_inicial INT; DECLARE @nombre_estado_inicial NVARCHAR(50) = 'RECOLECTADO'; SELECT @id_estado_inicial = id_estado_cadena FROM EstadoCadena WHERE nombre_estado = @nombre_estado_inicial AND activo = 1; IF @id_estado_inicial IS NULL BEGIN RAISERROR('El estado inicial de cadena de custodia "RECOLECTADO" no existe.', 16, 1); RETURN; END INSERT INTO Indicio (codigo_indicio, id_escena, id_tipo_indicio, descripcion_corta, ubicacion_especifica, fecha_hora_recoleccion, id_usuario_recolector, estado_actual, usuario_creacion) VALUES (@codigo_indicio, @id_escena, @id_tipo_indicio, @descripcion_corta, @ubicacion_especifica, @fecha_hora_recoleccion, @id_usuario_recolector, @nombre_estado_inicial, @usuario_creacion); SET @id_indicio = SCOPE_IDENTITY(); INSERT INTO CadenaCustodia (id_indicio, id_estado_cadena, fecha_movimiento, id_usuario_responsable, observaciones, usuario_creacion) VALUES (@id_indicio, @id_estado_inicial, @fecha_hora_recoleccion, @id_usuario_recolector, 'Indicio recolectado en escena.', @usuario_creacion); EXEC sp_Indicio_FindById @id_indicio; END
GO
CREATE PROCEDURE sp_Indicio_FindAll @codigo_caso NVARCHAR(50) = NULL, @id_fiscalia INT = NULL, @estado_actual NVARCHAR(50) = NULL, @activo BIT = NULL AS BEGIN SET NOCOUNT ON; SELECT i.id_indicio, i.codigo_indicio, i.id_escena, i.id_tipo_indicio, i.descripcion_corta, i.ubicacion_especifica, i.estado_actual, i.fecha_hora_recoleccion, i.activo, t.nombre_tipo AS tipo_indicio, e.nombre_escena, e.direccion_escena, inv.codigo_caso, inv.nombre_caso FROM Indicio i INNER JOIN TipoIndicio t ON i.id_tipo_indicio = t.id_tipo_indicio INNER JOIN Escena e ON i.id_escena = e.id_escena INNER JOIN Investigacion inv ON e.id_investigacion = inv.id_investigacion WHERE i.activo = ISNULL(@activo, i.activo) AND (@codigo_caso IS NULL OR inv.codigo_caso LIKE '%' + @codigo_caso + '%') AND (@id_fiscalia IS NULL OR inv.id_fiscalia = @id_fiscalia) AND (@estado_actual IS NULL OR i.estado_actual = @estado_actual) ORDER BY i.fecha_hora_recoleccion DESC; END
GO
CREATE PROCEDURE sp_Indicio_Update @id_indicio INT, @descripcion_corta NVARCHAR(255) = NULL, @ubicacion_especifica NVARCHAR(100) = NULL, @fecha_hora_recoleccion DATETIME = NULL, @id_tipo_indicio INT = NULL, @estado_actual NVARCHAR(50) = NULL, @activo BIT = NULL, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Indicio SET descripcion_corta = ISNULL(@descripcion_corta, descripcion_corta), ubicacion_especifica = ISNULL(@ubicacion_especifica, ubicacion_especifica), fecha_hora_recoleccion = ISNULL(@fecha_hora_recoleccion, fecha_hora_recoleccion), id_tipo_indicio = ISNULL(@id_tipo_indicio, id_tipo_indicio), estado_actual = ISNULL(@estado_actual, estado_actual), activo = ISNULL(@activo, activo), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_indicio = @id_indicio; END
GO
CREATE PROCEDURE sp_Indicio_Delete @id_indicio INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Indicio SET activo = 0, usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_indicio = @id_indicio; END
GO
CREATE PROCEDURE sp_CadenaCustodia_Move @id_indicio INT, @id_estado_cadena INT, @id_usuario_responsable INT, @observaciones NVARCHAR(MAX) = NULL, @documento_referencia NVARCHAR(100) = NULL, @usuario_creacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; DECLARE @nombre_nuevo_estado NVARCHAR(100); SELECT @nombre_nuevo_estado = nombre_estado FROM EstadoCadena WHERE id_estado_cadena = @id_estado_cadena AND activo = 1; IF @nombre_nuevo_estado IS NULL BEGIN RAISERROR('El estado de cadena de custodia seleccionado no es válido o está inactivo.', 16, 1); RETURN; END INSERT INTO CadenaCustodia (id_indicio, id_estado_cadena, id_usuario_responsable, observaciones, documento_referencia, usuario_creacion) VALUES (@id_indicio, @id_estado_cadena, @id_usuario_responsable, @observaciones, @documento_referencia, @usuario_creacion); UPDATE Indicio SET estado_actual = @nombre_nuevo_estado, usuario_actualizacion = @usuario_creacion, fecha_actualizacion = GETDATE() WHERE id_indicio = @id_indicio; SELECT * FROM CadenaCustodia WHERE id_cadena_custodia = SCOPE_IDENTITY(); END
GO
CREATE PROCEDURE sp_CadenaCustodia_FindByIndicio @id_indicio INT AS BEGIN SET NOCOUNT ON; SELECT cc.id_cadena_custodia, cc.fecha_movimiento, cc.observaciones, cc.documento_referencia, es.nombre_estado, u.nombre AS responsable_nombre, u.apellido AS responsable_apellido FROM CadenaCustodia cc INNER JOIN EstadoCadena es ON cc.id_estado_cadena = es.id_estado_cadena INNER JOIN Usuario u ON cc.id_usuario_responsable = u.id_usuario WHERE cc.id_indicio = @id_indicio ORDER BY cc.fecha_movimiento ASC; END
GO

-- SPs de Flujo y Reporte DICRI
CREATE PROCEDURE sp_Investigacion_SendToReview @id_investigacion INT, @usuario_envio NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Investigacion SET estado_revision_dicri = 'PENDIENTE_REVISION', id_usuario_revision = NULL, justificacion_revision = NULL, fecha_revision = GETDATE(), usuario_actualizacion = @usuario_envio, fecha_actualizacion = GETDATE() WHERE id_investigacion = @id_investigacion AND estado_revision_dicri IN ('EN_REGISTRO', 'RECHAZADO'); IF @@ROWCOUNT = 0 BEGIN RAISERROR('No se pudo enviar el expediente a revisión. Verifique su estado actual (EN_REGISTRO o RECHAZADO).', 16, 1); END END
GO
CREATE PROCEDURE sp_Investigacion_Approve @id_investigacion INT, @id_usuario_coordinador INT, @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; UPDATE Investigacion SET estado_revision_dicri = 'APROBADO', id_usuario_revision = @id_usuario_coordinador, justificacion_revision = 'Aprobado sin observaciones.', fecha_revision = GETDATE(), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_investigacion = @id_investigacion AND estado_revision_dicri IN ('PENDIENTE_REVISION', 'RECHAZADO'); IF @@ROWCOUNT = 0 BEGIN RAISERROR('No se pudo aprobar el expediente. Debe estar en estado PENDIENTE_REVISION o RECHAZADO.', 16, 1); END END
GO
CREATE PROCEDURE sp_Investigacion_Reject @id_investigacion INT, @id_usuario_coordinador INT, @justificacion NVARCHAR(MAX), @usuario_actualizacion NVARCHAR(50) AS BEGIN SET NOCOUNT ON; IF @justificacion IS NULL OR LTRIM(RTRIM(@justificacion)) = '' BEGIN RAISERROR('La justificación de rechazo es obligatoria.', 16, 1); RETURN; END UPDATE Investigacion SET estado_revision_dicri = 'RECHAZADO', id_usuario_revision = @id_usuario_coordinador, justificacion_revision = @justificacion, fecha_revision = GETDATE(), usuario_actualizacion = @usuario_actualizacion, fecha_actualizacion = GETDATE() WHERE id_investigacion = @id_investigacion AND estado_revision_dicri = 'PENDIENTE_REVISION'; IF @@ROWCOUNT = 0 BEGIN RAISERROR('No se pudo rechazar el expediente. Debe estar en estado PENDIENTE_REVISION.', 16, 1); END END
GO
CREATE PROCEDURE sp_Reporte_Revision_Expedientes @fecha_inicio DATETIME = NULL, @fecha_fin DATETIME = NULL, @estado_revision NVARCHAR(50) = NULL AS BEGIN SET NOCOUNT ON; SELECT i.codigo_caso, i.nombre_caso, f.nombre_fiscalia, i.fecha_creacion AS fecha_registro, u_reg.nombre + ' ' + u_reg.apellido AS tecnico_registra, i.estado_revision_dicri AS estado_actual, i.fecha_revision AS fecha_revision, u_rev.nombre + ' ' + u_rev.apellido AS coordinador_revision, i.justificacion_revision FROM Investigacion i INNER JOIN Fiscalia f ON i.id_fiscalia = f.id_fiscalia INNER JOIN Usuario u_reg ON i.id_usuario_registro = u_reg.id_usuario LEFT JOIN Usuario u_rev ON i.id_usuario_revision = u_rev.id_usuario WHERE i.activo = 1 AND (@estado_revision IS NULL OR i.estado_revision_dicri = @estado_revision) AND (@fecha_inicio IS NULL OR i.fecha_creacion >= @fecha_inicio) AND (@fecha_fin IS NULL OR i.fecha_creacion <= DATEADD(day, 1, @fecha_fin)) ORDER BY i.fecha_creacion DESC; END
GO

PRINT 'Procedimientos almacenados creados exitosamente.';
GO

-- =============================================
-- 4. DATOS INICIALES Y DE EJEMPLO (DML)
-- =============================================
BEGIN
    -- Declaración de Variables locales
    DECLARE @ClaveHash NVARCHAR(255) = '0192023a7bbd73250516f069df18b500'; -- Hash de 'admin123'
    DECLARE @SYSTEM NVARCHAR(50) = 'SYSTEM';
    DECLARE @id_fiscalia INT;
    DECLARE @id_usuario_tecnico INT;
    DECLARE @id_usuario_coordinador INT;
    DECLARE @id_tipo_arma INT;

    -- 4.1 Roles de Seguridad y Perfiles base
    INSERT INTO [dbo].[Perfil] ([nombre_perfil], [descripcion], [usuario_creacion]) VALUES 
        ('Administrador', 'Perfil con acceso total al sistema', @SYSTEM),
        ('Técnico DICRI', 'Perfil para técnicos que registran expedientes e indicios', @SYSTEM),
        ('Coordinador DICRI', 'Perfil para coordinadores que revisan y aprueban expedientes', @SYSTEM);

    INSERT INTO [dbo].[Role] ([nombre_role], [descripcion], [usuario_creacion]) VALUES 
        ('ADMIN', 'Role de administrador del sistema', @SYSTEM),
        ('TECNICO_DICRI', 'Rol para técnicos que registran indicios y envían a revisión.', @SYSTEM),
        ('COORDINADOR_DICRI', 'Rol para coordinadores que aprueban o rechazan expedientes.', @SYSTEM);

    -- 4.2 Usuarios de Ejemplo
    INSERT INTO [dbo].[Usuario] ([nombre_usuario], [clave], [nombre], [apellido], [email], [activo], [cambiar_clave], [intentos_fallidos], [usuario_creacion]) VALUES 
        ('admin', @ClaveHash, 'Administrador', 'Sistema', 'admin@dicri.com', 1, 1, 0, @SYSTEM), 
        ('tec_1', @ClaveHash, 'Juan', 'Perez', 'juan.perez@dicri.com', 1, 0, 0, @SYSTEM), 
        ('coor_1', @ClaveHash, 'Maria', 'Lopez', 'maria.lopez@dicri.com', 1, 0, 0, @SYSTEM);

    -- Asignación de IDs de usuario
    SELECT @id_usuario_tecnico = id_usuario FROM Usuario WHERE nombre_usuario = 'tec_1';
    SELECT @id_usuario_coordinador = id_usuario FROM Usuario WHERE nombre_usuario = 'coor_1';

    -- 4.3 Asignación Perfil - Usuario
    -- admin = Perfil Administrador (id_perfil = 1)
    -- tec_1 = Perfil Técnico DICRI (id_perfil = 2)
    -- coor_1 = Perfil Coordinador DICRI (id_perfil = 3)
    INSERT INTO [dbo].[Usuario_Perfil] ([id_usuario], [id_perfil], [usuario_creacion]) VALUES 
        (1, 1, @SYSTEM), 
        (@id_usuario_tecnico, 2, @SYSTEM), 
        (@id_usuario_coordinador, 3, @SYSTEM);

    -- 4.4 Asignación Role - Perfil
    -- Perfil 1 (Administrador) -> Role ADMIN
    -- Perfil 2 (Técnico DICRI) -> Role TECNICO_DICRI
    -- Perfil 3 (Coordinador DICRI) -> Role COORDINADOR_DICRI
    INSERT INTO [dbo].[Perfil_Role] ([id_perfil], [id_role], [usuario_creacion]) VALUES 
        (1, 1, @SYSTEM), 
        (2, 2, @SYSTEM), 
        (3, 3, @SYSTEM);    -- 4.5 Creación de Módulos (Simplificado)
    INSERT INTO [dbo].[Modulo] ([nombre_modulo], [descripcion], [ruta], [icono], [orden], [usuario_creacion]) VALUES 
        ('Dashboard', 'Vista principal del sistema', '/dashboard', 'home', 1, @SYSTEM),                   
        ('Gestión de Expedientes', 'Registro de investigaciones, escenas e indicios.', '/expedientes', 'folder', 10, @SYSTEM), 
        ('Revisión de Expedientes', 'Aprobar o rechazar expedientes DICRI.', '/revision', 'check-square', 11, @SYSTEM),    
        ('Informes y Estadísticas', 'Generación de reportes.', '/reportes', 'bar-chart', 20, @SYSTEM), 
        ('Administración', 'Gestión de usuarios, roles y catálogos.', '/admin', 'settings', 90, @SYSTEM); 
    
    -- 4.6 Asignación Perfil-Módulo
-- Administrador (Perfil 1) tiene acceso a todos los módulos
INSERT INTO [dbo].[Perfil_Modulo] ([id_perfil], [id_modulo], [usuario_creacion])
SELECT 1, id_modulo, @SYSTEM
FROM Modulo
WHERE activo = 1;

-- Técnico DICRI (Perfil 2) tiene acceso a Dashboard, Gestión de Expedientes
INSERT INTO [dbo].[Perfil_Modulo] ([id_perfil], [id_modulo], [usuario_creacion])
SELECT 2, id_modulo, @SYSTEM
FROM Modulo
WHERE nombre_modulo IN ('Dashboard', 'Gestión de Expedientes')
AND activo = 1;

-- Coordinador DICRI (Perfil 3) tiene acceso a Dashboard, Revisión de Expedientes, Informes y Estadísticas
INSERT INTO [dbo].[Perfil_Modulo] ([id_perfil], [id_modulo], [usuario_creacion])
SELECT 3, id_modulo, @SYSTEM
FROM Modulo
WHERE nombre_modulo IN ('Dashboard', 'Revisión de Expedientes', 'Informes y Estadísticas')
AND activo = 1;    -- 4.7 (Se omite la inserción de Role_Modulo por concisión, si se desea, se puede incluir el código de la versión 4.0)
    
    -- 4.8 Catálogos y Ejemplos de Negocio
    INSERT INTO [dbo].[EstadoRevisionDICRI] (nombre_estado, descripcion, usuario_creacion) VALUES 
        ('EN_REGISTRO', 'Expediente siendo completado por el técnico.', @SYSTEM),
        ('PENDIENTE_REVISION', 'Expediente listo para la revisión del coordinador.', @SYSTEM),
        ('APROBADO', 'Expediente revisado y validado.', @SYSTEM),
        ('RECHAZADO', 'Expediente revisado y requiere corrección.', @SYSTEM);

    INSERT INTO [dbo].[TipoIndicio] (nombre_tipo, descripcion, usuario_creacion) VALUES 
        ('Arma de Fuego', 'Armas de cualquier tipo y calibre.', @SYSTEM),             
        ('Sustancia Ilícita', 'Drogas, precursores y derivados.', @SYSTEM),          
        ('Equipo Digital', 'Teléfonos, computadoras, discos duros.', @SYSTEM);       
    SELECT @id_tipo_arma = id_tipo_indicio FROM TipoIndicio WHERE nombre_tipo = 'Arma de Fuego';

    INSERT INTO [dbo].[EstadoCadena] (nombre_estado, descripcion, usuario_creacion) VALUES 
        ('RECOLECTADO', 'Indicio recién levantado en escena.', @SYSTEM),
        ('TRASLADO', 'Indicio en tránsito hacia laboratorio/almacén.', @SYSTEM),
        ('EN_ANALISIS', 'Indicio siendo peritado en laboratorio.', @SYSTEM);

    -- Fiscalía de Ejemplo
    INSERT INTO [dbo].[Fiscalia] (nombre_fiscalia, direccion, usuario_creacion) VALUES ('Fiscalía de Delitos contra la Vida', 'Ciudad de Guatemala, Zona 1', @SYSTEM);
    SELECT @id_fiscalia = SCOPE_IDENTITY();

    -- DECLARACIONES PARA EJECUCIÓN DEL FLUJO
    DECLARE @id_investigacion_en_registro INT;
    DECLARE @id_escena_1 INT;
    
    -- Expediente de Ejemplo 1: EN REGISTRO (Técnico lo está creando)
    INSERT INTO Investigacion (codigo_caso, nombre_caso, fecha_inicio, id_fiscalia, id_usuario_registro, descripcion_hechos, usuario_creacion)
    VALUES ('MP001-2025-1001', 'Homicidio en Zona 10', '2025-11-20', @id_fiscalia, @id_usuario_tecnico, 'Investigación sobre el hallazgo de un cuerpo con herida de bala.', 'tec_1');
    SELECT @id_investigacion_en_registro = SCOPE_IDENTITY();
    
    -- Inserción de Escena para el Expediente 1
    INSERT INTO Escena (id_investigacion, nombre_escena, direccion_escena, fecha_hora_inicio, fecha_hora_fin, descripcion, usuario_creacion)
    VALUES (@id_investigacion_en_registro, 'Lugar del Crimen', 'Avenida Reforma, Edificio X', '2025-11-20 08:00:00', '2025-11-20 12:00:00', 'Recolección inicial de evidencia balística.', 'tec_1');
    SELECT @id_escena_1 = SCOPE_IDENTITY();

    -- Indicio 1 (registrado por el técnico)
    EXEC sp_Indicio_Create 
        @codigo_indicio = 'DICRI-1001-001', @id_escena = @id_escena_1, @id_tipo_indicio = @id_tipo_arma, 
        @descripcion_corta = 'Pistola calibre 9mm, color negro.', @ubicacion_especifica = 'Junto al cuerpo, a 50cm del brazo derecho.', 
        @fecha_hora_recoleccion = '2025-11-20 09:30:00', @id_usuario_recolector = @id_usuario_tecnico, @usuario_creacion = 'tec_1';


    -- Expediente de Ejemplo 2: PENDIENTE DE REVISIÓN
    INSERT INTO Investigacion (codigo_caso, nombre_caso, fecha_inicio, id_fiscalia, id_usuario_registro, descripcion_hechos, usuario_creacion)
    VALUES ('MP001-2025-1002', 'Robo Agravado', '2025-10-15', @id_fiscalia, @id_usuario_tecnico, 'Análisis de equipo electrónico robado.', 'tec_1');
    DECLARE @id_investigacion_pendiente INT = SCOPE_IDENTITY();
    
    EXEC sp_Investigacion_SendToReview @id_investigacion = @id_investigacion_pendiente, @usuario_envio = 'tec_1';

    -- Expediente de Ejemplo 3: APROBADO 
    INSERT INTO Investigacion (codigo_caso, nombre_caso, fecha_inicio, id_fiscalia, descripcion_hechos, estado_revision_dicri, id_usuario_registro, id_usuario_revision, justificacion_revision, fecha_revision, usuario_creacion)
    VALUES ('MP001-2025-1003', 'Incautación de Drogas', '2025-10-01', @id_fiscalia, 'Paquetes de clorhidrato de cocaína', 'APROBADO', @id_usuario_tecnico, @id_usuario_coordinador, 'Registro completo y cadena de custodia validada. Archivo finalizado.', GETDATE(), 'tec_1');

    -- Expediente de Ejemplo 4: RECHAZADO
    INSERT INTO Investigacion (codigo_caso, nombre_caso, fecha_inicio, id_fiscalia, descripcion_hechos, estado_revision_dicri, id_usuario_registro, id_usuario_revision, justificacion_revision, fecha_revision, usuario_creacion)
    VALUES ('MP001-2025-1004', 'Fraude Digital', '2025-11-01', @id_fiscalia, 'Incautación de servidor.', 'RECHAZADO', @id_usuario_tecnico, @id_usuario_coordinador, 'Faltan campos de metadatos en el registro de los equipos digitales. Favor complementar.', GETDATE(), 'coor_1');
END
GO

PRINT 'Datos iniciales y de ejemplo insertados exitosamente. El script de documentación ha finalizado.'