 /*            NUEVO USUARIO          */
 USE master;
GO

-- Crear un nuevo login (usuario a nivel de servidor)
CREATE LOGIN jurigo_user 
WITH PASSWORD = 'TuPasswordSeguro123Ph@nt0m.Key-b0ard_79!',
CHECK_POLICY = OFF;  -- Solo para desarrollo, en producción usar CHECK_POLICY = ON
GO

-- Dar permisos de administrador (solo para desarrollo)
ALTER SERVER ROLE sysadmin ADD MEMBER jurigo_user;
GO

-- Ahora, para tu base de datos específica
USE JurigoDB;
GO

-- Crear un usuario en la base de datos 'JunigoDB' asociado al login
CREATE USER jurigo_user FOR LOGIN jurigo_user;
GO

-- Dar permisos de dueño de la base de datos (solo para desarrollo)
ALTER ROLE db_owner ADD MEMBER jurigo_user;
GO

------------------------------------------------------------------------
--------¿Jurigo_user está desbloqueado y habilitado?
-----------Ejecuta esta consulta en SSMS para asegurarlo:*/
------------------------------------------------------------------------

SELECT name, is_disabled
FROM sys.sql_logins
WHERE name = 'jurigo_user';

--- Si is_disabled = 1, ejecuta esto para activarlo:
ALTER LOGIN jurigo_user ENABLE;

------------------------------------------------------------------------
---------------Verificar el nuevo usuario-------------------------------
-- Verificar logins
SELECT name, type_desc FROM sys.server_principals WHERE type = 'S';

-- Verificar usuarios en JunigoDB
	
SELECT name, type_desc FROM sys.database_principals WHERE type = 'S';
------------------------------------------------------------------------
------------------------------------------------------------------------
/***********************************************************************/
/***********************************************************************/

-- Crear base de datos
CREATE DATABASE JurigoDB;
GO

drop database JurigoDB;
GO

USE JurigoDB;
GO


CREATE TABLE SesionUsuarios (
  SesionID INT IDENTITY(1,1) PRIMARY KEY,
  UsuarioID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
  FechaInicio DATETIME NOT NULL DEFAULT GETDATE(),
  FechaFin DATETIME NULL,
  Estado NVARCHAR(20) NOT NULL DEFAULT 'Activa',
  Observaciones NVARCHAR(255) NULL
);


SELECT * FROM Usuarios WHERE Estado = 'Activo';
select * from Usuarios;
-- Tabla de Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(50) NOT NULL DEFAULT 'Abogado',
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    UltimoLogin DATETIME NULL,
    AvatarURL NVARCHAR(255) NULL,
    Estado NVARCHAR(20) NOT NULL DEFAULT 'Activo' -- Activo, Inactivo
);
GO



CREATE PROCEDURE InsertarUsuario
    @Nombre NVARCHAR(100),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255),
    @Rol NVARCHAR(50) = NULL,
    @UltimoLogin DATETIME = NULL,
    @AvatarURL NVARCHAR(255) = NULL,
    @Estado NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Usuarios (
        Nombre,
        Email,
        PasswordHash,
        Rol,
        UltimoLogin,
        AvatarURL,
        Estado
    )
    VALUES (
        @Nombre,
        @Email,
        @PasswordHash,
        ISNULL(@Rol, 'Abogado'),      -- Valor predeterminado si es NULL
        @UltimoLogin,                  -- Permite NULL
        @AvatarURL,                    -- Permite NULL
        ISNULL(@Estado, 'Activo')      -- Valor predeterminado si es NULL
    );
    
    -- Retorna el ID del nuevo usuario
    SELECT SCOPE_IDENTITY() AS UsuarioID;
END
GO

-- Insertar un usuario con valores mínimos
EXEC InsertarUsuario
    @Nombre = 'ED',
    @Email = 'ED@gmail.com.com',
    @PasswordHash = 'ABC123XYZ';

-- Insertar con todos los parámetros
EXEC InsertarUsuario
    @Nombre = 'edu',
    @Email = 'edu@gmail.com',
    @PasswordHash = '123',
    @Rol = 'Socio',
    @UltimoLogin = '2025-06-18 09:30:00',
    @AvatarURL = 'https://ejemplo.com/avatar.jpg',
    @Estado = 'Inactivo';

-- Tabla de Clientes
CREATE TABLE Clientes ( 
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Empresa NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    Telefono NVARCHAR(20) NULL,
    Direccion NVARCHAR(255) NULL,
    TipoCliente NVARCHAR(50) NOT NULL, -- Corporativo, Ambiental, etc.
    Notas TEXT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    UsuarioResponsableID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID)
);
GO   

-- Tabla de Casos
CREATE TABLE Casos (
    CasoID INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(255) NOT NULL,
    Descripcion TEXT NULL,
    Estado NVARCHAR(20) NOT NULL DEFAULT 'Activo', -- Activo, Pendiente, Cerrado
    AreaLegal NVARCHAR(50) NOT NULL, -- Corporativo, Ambiental, etc.
    FechaInicio DATE NOT NULL,
    FechaCierre DATE NULL,
    ClienteID INT NOT NULL FOREIGN KEY REFERENCES Clientes(ClienteID),
    UsuarioResponsableID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabla de Documentos con restricción de integridad
CREATE TABLE Documentos (  
    DocumentoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(255) NOT NULL,
    Descripcion TEXT NULL,
    Tipo NVARCHAR(50) NOT NULL, -- Contrato, Demanda, Sentencia, etc.
    RutaArchivo NVARCHAR(255) NOT NULL,
    Tamano BIGINT NOT NULL, -- En bytes
    CasoID INT NULL,
    ClienteID INT NULL,
    UsuarioSubioID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    FechaSubida DATETIME NOT NULL DEFAULT GETDATE(),
    Etiquetas NVARCHAR(255) NULL,
    
    -- Restricción para asegurar relación con Caso o Cliente
    CONSTRAINT FK_Documentos_Caso FOREIGN KEY (CasoID) REFERENCES Casos(CasoID),
    CONSTRAINT FK_Documentos_Cliente FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    CONSTRAINT CHK_Documentos_Relacion CHECK (CasoID IS NOT NULL OR ClienteID IS NOT NULL)
);
GO

-- Tabla de Eventos (Calendario)
CREATE TABLE Eventos ( 
    EventoID INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(255) NOT NULL,
    Descripcion TEXT NULL,
    Tipo NVARCHAR(50) NOT NULL, -- Audiencia, Reunión, Tarea, Plazo
    FechaInicio DATETIME NOT NULL,
    FechaFin DATETIME NOT NULL,
    Ubicacion NVARCHAR(255) NULL,
    RecordatorioMinutos INT NULL, -- Minutos antes para recordar
    CasoID INT NULL FOREIGN KEY REFERENCES Casos(CasoID),
    ClienteID INT NULL FOREIGN KEY REFERENCES Clientes(ClienteID),
    UsuarioCreadorID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabla de Participantes de Eventos con restricción única
CREATE TABLE EventoParticipantes (  
    ParticipanteID INT IDENTITY(1,1) PRIMARY KEY,
    EventoID INT NOT NULL FOREIGN KEY REFERENCES Eventos(EventoID),
    UsuarioID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    Confirmacion NVARCHAR(20) NULL, -- Confirmado, Pendiente, Rechazado
    
    -- Evitar duplicados de participantes
    CONSTRAINT UQ_EventoUsuario UNIQUE (EventoID, UsuarioID)
);
GO

-- Tabla de Mensajes (Chat)
CREATE TABLE Mensajes (  
    MensajeID INT IDENTITY(1,1) PRIMARY KEY,
    Contenido TEXT NOT NULL,
    FechaEnvio DATETIME NOT NULL DEFAULT GETDATE(),
    UsuarioEnviaID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    UsuarioRecibeID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    Leido BIT NOT NULL DEFAULT 0,
    Tipo NVARCHAR(20) NOT NULL DEFAULT 'Texto' -- Texto, Archivo, Imagen
);
GO

-- Tabla de Notificaciones
CREATE TABLE Notificaciones (   
    NotificacionID INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(255) NOT NULL,
    Mensaje TEXT NOT NULL,
    Tipo NVARCHAR(50) NOT NULL, -- Sistema, Evento, Documento, etc.
    UsuarioID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    Leida BIT NOT NULL DEFAULT 0,
    Enlace NVARCHAR(255) NULL
);
GO

-- Tabla de Actividades (Log de acciones)
CREATE TABLE Actividades (  
    ActividadID INT IDENTITY(1,1) PRIMARY KEY,
    Accion NVARCHAR(100) NOT NULL, -- Creó caso, Editó documento, etc.
    Detalles TEXT NULL,
    UsuarioID INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    EntidadAfectada NVARCHAR(50) NULL, -- Casos, Clientes, etc.
    EntidadID INT NULL -- ID de la entidad afectada
);
GO

-- Tabla de Configuraciones
CREATE TABLE Configuraciones (   
    ConfiguracionID INT IDENTITY(1,1) PRIMARY KEY,
    Clave NVARCHAR(100) UNIQUE NOT NULL,
    Valor NVARCHAR(255) NOT NULL,
    Descripcion TEXT NULL
);
GO

CREATE TABLE Tareas (
    TareaID INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(100) NOT NULL,
    Descripcion TEXT NULL,
    Estado NVARCHAR(20) NOT NULL DEFAULT 'Pendiente',     -- Pendiente, En progreso, Completada
    Prioridad NVARCHAR(20) NOT NULL DEFAULT 'Media',      -- Baja, Media, Alta, Urgente
    FechaLimite DATE NULL,
    UsuarioAsignadoID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    CasoID INT NULL FOREIGN KEY REFERENCES Casos(CasoID),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);

-- Insertar configuraciones iniciales
INSERT INTO Configuraciones (Clave, Valor, Descripcion)
VALUES 
    ('TAMANO_MAX_DOCUMENTO', '52428800', 'Tamaño máximo de documentos en bytes (100MB)'),
    ('FORMATOS_PERMITIDOS', 'pdf,doc,docx,xls,xlsx,jpg,png', 'Formatos de archivo permitidos'),
    ('TIEMPO_SESION', '480', 'Tiempo de sesión en minutos (8 horas)');
GO

-- Crear índices para mejorar el rendimiento
CREATE INDEX IDX_Casos_Cliente ON Casos(ClienteID);
CREATE INDEX IDX_Documentos_Caso ON Documentos(CasoID);
CREATE INDEX IDX_Eventos_FechaInicio ON Eventos(FechaInicio);
CREATE INDEX IDX_Mensajes_UsuarioRecibe ON Mensajes(UsuarioRecibeID);
CREATE INDEX IDX_Notificaciones_Usuario ON Notificaciones(UsuarioID);
CREATE INDEX IDX_Actividades_UsuarioFecha ON Actividades(UsuarioID, Fecha DESC);
CREATE INDEX IDX_Eventos_UsuarioFecha ON Eventos(UsuarioCreadorID, FechaInicio);
CREATE INDEX IDX_Documentos_UsuarioFecha ON Documentos(UsuarioSubioID, FechaSubida DESC);
CREATE INDEX IDX_Mensajes_RecibeLeidoFecha ON Mensajes(UsuarioRecibeID, Leido, FechaEnvio DESC);
GO

-- Crear vistas útiles
CREATE VIEW VistaCasosActivos AS
SELECT 
    c.CasoID,
    c.Titulo,
    c.Descripcion,
    c.Estado,
    c.AreaLegal,
    c.FechaInicio,
    c.FechaCierre,
    c.FechaCreacion,
    cl.ClienteID,
    cl.Nombre AS NombreCliente,
    u.UsuarioID,
    u.Nombre AS NombreResponsable
FROM Casos c
JOIN Clientes cl ON c.ClienteID = cl.ClienteID
JOIN Usuarios u ON c.UsuarioResponsableID = u.UsuarioID
WHERE c.Estado = 'Activo';
GO

CREATE VIEW VistaProximosEventos AS
SELECT TOP 10 
    e.EventoID,
    e.Titulo,
    e.Descripcion,
    e.Tipo,
    e.FechaInicio,
    e.FechaFin,
    e.Ubicacion,
    e.RecordatorioMinutos,
    c.CasoID,
    c.Titulo AS TituloCaso,
    cl.ClienteID,
    cl.Nombre AS NombreCliente
FROM Eventos e
LEFT JOIN Casos c ON e.CasoID = c.CasoID
LEFT JOIN Clientes cl ON e.ClienteID = cl.ClienteID
WHERE e.FechaInicio > GETDATE()
ORDER BY e.FechaInicio ASC;
GO

-- Crear procedimientos almacenados
drop procedure sp_LoginUsuario
-- Crear procedimientos almacenados
CREATE PROCEDURE sp_LoginUsuario
    @Email NVARCHAR(100),
    @Password NVARCHAR(255)
AS
BEGIN
    SELECT  
        UsuarioID,  
        Nombre,  
        Email,  
        Rol,  
        AvatarURL,
        Estado
    FROM Usuarios
    WHERE Email = @Email 
      AND PasswordHash = @Password;
END
GO
--
CREATE PROCEDURE sp_ReactivarUsuario
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON; -- Primero: Desactivar contadores

    IF EXISTS (
        SELECT 1 FROM Usuarios
        WHERE UsuarioID = @UsuarioID AND Estado = 'Inactivo'
    )
    BEGIN
        UPDATE Usuarios
        SET Estado = 'Activo'
        WHERE UsuarioID = @UsuarioID;

        SELECT 'Reactivado' AS Resultado; -- Éxito
    END
    ELSE
    BEGIN
        SELECT 'Usuario_No_Reactivado' AS Resultado; -- Fallo
    END
END;
GO

EXEC sp_ReactivarUsuario @UsuarioID = @UsuarioID;
select * from Usuarios;
select * from SesionUsuarios; 

CREATE PROCEDURE sp_DesactivarUsuario
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica si el usuario está activo
    IF EXISTS (
        SELECT 1 FROM Usuarios
        WHERE UsuarioID = @UsuarioID AND Estado = 'Activo'
    )
    BEGIN
        UPDATE Usuarios
        SET Estado = 'Inactivo'
        WHERE UsuarioID = @UsuarioID;

        PRINT '🛑 Usuario desactivado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'ℹ️ El usuario ya estaba inactivo o no existe.';
    END
END;
GO

EXEC sp_DesactivarUsuario @UsuarioID = @UsuarioID;
select * from Usuarios;
select * from SesionUsuarios;           drop table SesionUsuarios;



CREATE PROCEDURE sp_ObtenerDocumentosCaso
    @CasoID INT
AS
BEGIN
    SELECT 
        d.DocumentoID,
        d.Nombre,
        d.Descripcion,
        d.Tipo,
        d.RutaArchivo,
        d.Tamano,
        d.FechaSubida,
        d.Etiquetas,
        u.Nombre AS NombreUsuario
    FROM Documentos d
    JOIN Usuarios u ON d.UsuarioSubioID = u.UsuarioID
    WHERE d.CasoID = @CasoID
    ORDER BY d.FechaSubida DESC;
END
GO

CREATE PROCEDURE sp_RegistrarActividad
    @UsuarioID INT,
    @Accion NVARCHAR(100),
    @Detalles TEXT,
    @EntidadAfectada NVARCHAR(50) = NULL,
    @EntidadID INT = NULL
AS
BEGIN
    INSERT INTO Actividades (
        UsuarioID, 
        Accion, 
        Detalles, 
        EntidadAfectada, 
        EntidadID
    )
    VALUES (
        @UsuarioID, 
        @Accion, 
        @Detalles, 
        @EntidadAfectada, 
        @EntidadID
    );
END
GO

CREATE PROCEDURE sp_ResumenDashboard
AS
BEGIN
    SELECT
        -- Total de casos activos
        (SELECT COUNT(*) FROM Casos WHERE Estado = 'Activo') AS casosActivos,

        -- Total de eventos con FechaInicio hoy (audiencias/citas)
        (SELECT COUNT(*) 
         FROM Eventos 
         WHERE CONVERT(date, FechaInicio) = CONVERT(date, GETDATE())) AS citasHoy,
		 
        -- Total de tareas pendientes
        (SELECT COUNT(*) FROM Tareas WHERE Estado = 'Pendiente') AS tareasPendientes;
END
GO
-- Total de tareas pendientes
(SELECT COUNT(*) FROM Tareas WHERE Estado = 'Pendiente') 


/**/
SELECT TOP 5 * FROM SesionUsuarios ORDER BY SesionID DESC;
select * from Usuarios;
select * from SesionUsuarios;    
select * from Clientes;
 select * from Casos;
  select * from Documentos;
   select * from Eventos;
    select * from EventoParticipantes; 
	 select * from Mensajes ;
	  select * from Notificaciones ;
	  select * from Actividades ;
	   select * from Configuraciones;
	    select * from Tareas;
---------------------------------------------------------------------
-------------------------------------------------------------------
-----------------------------------------------------------------------
------------------------------------------------------------------------
CREATE PROCEDURE sp_ResumenDashboardPorUsuario
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        -- Casos activos asignados al usuario
        (SELECT COUNT(*) FROM Casos WHERE UsuarioResponsableID = @UsuarioID AND Estado = 'Activo') AS CasosActivos,

        -- Nuevos casos esta semana
        (SELECT COUNT(*) 
         FROM Casos 
         WHERE UsuarioResponsableID = @UsuarioID 
           AND Estado = 'Activo' 
           AND FechaCreacion >= DATEADD(DAY, -7, GETDATE())) AS NuevosCasosSemana,

        -- Citas del día creadas por el usuario
        (SELECT COUNT(*) 
         FROM Eventos 
         WHERE UsuarioCreadorID = @UsuarioID 
           AND CONVERT(date, FechaInicio) = CONVERT(date, GETDATE())) AS CitasHoy,

        -- Próxima cita futura
        (SELECT TOP 1 FORMAT(FechaInicio, 'HH:mm dd/MM') 
         FROM Eventos 
         WHERE UsuarioCreadorID = @UsuarioID 
           AND FechaInicio > GETDATE()
         ORDER BY FechaInicio ASC) AS ProximaCita,

        -- Tareas pendientes asignadas
        (SELECT COUNT(*) FROM Tareas WHERE UsuarioAsignadoID = @UsuarioID AND Estado = 'Pendiente') AS TareasPendientes,

        -- Tareas urgentes
        (SELECT COUNT(*) FROM Tareas WHERE UsuarioAsignadoID = @UsuarioID AND Estado = 'Pendiente' AND Prioridad = 'Urgente') AS TareasUrgentes
END


CREATE PROCEDURE sp_CasosRecientesDashboard
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 6
        c.CasoID,
        c.Titulo,
        cl.Nombre AS Cliente,
        c.AreaLegal,
        u.Nombre AS Responsable,
        c.Estado,
        c.FechaCreacion
    FROM Casos c
    INNER JOIN Clientes cl ON c.ClienteID = cl.ClienteID
    INNER JOIN Usuarios u ON c.UsuarioResponsableID = u.UsuarioID
    WHERE c.UsuarioResponsableID = @UsuarioID
    ORDER BY c.FechaCreacion DESC;
END
	   

