/* INSERTAR DATOS */
USE JurigoDB;
GO

INSERT INTO Usuarios (ID, Nombre, Correo, Rol, Password)
VALUES
(1, 'Elena Gómez', 'elena@jurigo.mx', 'Abogada', '1234'),
(2, 'Carlos Duarte', 'carlos@jurigo.mx', 'Abogado', '1234'),
(3, 'Luis Rivera', 'luis@jurigo.mx', 'Cliente', '1234'),
(4, 'Ana Ortega', 'ana@jurigo.mx', 'Abogada', '1234'),
(5, 'Roberto Luna', 'roberto@jurigo.mx', 'Cliente', '1234');

INSERT INTO Usuarios (Nombre, Email, PasswordHash, Rol, Estado)
VALUES
('Daniel Torres', 'daniel.torres@gmail.com', '1234', 'Abogado', 'Activo'),
('Sofía Castillo', 'sofi.castillo@hotmail.com', '1234', 'Abogada', 'Activo'),
('Luis Romero', 'luis.romero@outlook.com', '1234', 'Abogado', 'Activo'),
('Gabriela Méndez', 'gabriela.mendez@gmail.com', '1234', 'Socia', 'Activo'),
('Carlos Ibáñez', 'carlos.ibanez@hotmail.com', '1234', 'Socio', 'Activo');


INSERT INTO Clientes (Nombre, Empresa, Email, Telefono, Direccion, TipoCliente, UsuarioResponsableID)
VALUES
('María Gómez', 'Consultoría MG', 'maria.gomez@mg.mx', '555-1234', 'Av. Reforma 123, CDMX', 'Corporativo', 1),
('Jorge Navarro', 'Estudio Legal Navarro', 'jorge.navarro@hotmail.com', '555-2345', 'Insurgentes Sur 456, CDMX', 'Civil', 2),
('Isabel Romero', 'Clínica Integral', 'isabel.romero@clinicai.mx', '555-3456', 'Altavista 789, CDMX', 'Médico', 3),
('Daniela Salas', NULL, 'daniela.salas@gmail.com', '555-4567', 'Roma Norte 321, CDMX', 'Familiar', 4),
('Andrés López', 'EcoVerde SA', 'andres.lopez@ecoverde.mx', '555-5678', 'Polanco 654, CDMX', 'Ambiental', 5);

INSERT INTO Casos (Titulo, Descripcion, Estado, AreaLegal, FechaInicio, ClienteID, UsuarioResponsableID)
VALUES
('Divorcio Gómez', 'Separación legal y custodia compartida', 'Activo', 'Familiar', '2024-06-01', 1, 1),
('Demanda Laboral Navarro', 'Reclamación por despido injustificado', 'Activo', 'Laboral', '2024-06-03', 2, 2),
('Negociación de Contrato Clínica', 'Revisión de contrato de servicios médicos', 'Pendiente', 'Corporativo', '2024-06-04', 3, 3),
('Herencia Salas', 'Distribución de bienes por testamento', 'Activo', 'Civil', '2024-06-05', 4, 4),
('Demanda Ambiental EcoVerde', 'Contaminación de suelo en zona protegida', 'Activo', 'Ambiental', '2024-06-06', 5, 5);


INSERT INTO Tareas (Titulo, Descripcion, Estado, Prioridad, FechaLimite, UsuarioAsignadoID, CasoID)
VALUES
('Redactar escrito inicial', 'Documento de demanda para el caso de divorcio', 'Pendiente', 'Alta', '2024-07-01', 1, 1),
('Preparar pruebas laborales', 'Compilar evidencias y testimonios', 'Pendiente', 'Media', '2024-07-02', 2, 2),
('Revisar contrato', 'Análisis legal de cláusulas especiales', 'Pendiente', 'Alta', '2024-07-03', 3, 3),
('Coordinación con notaría', 'Organizar cita para validación de testamento', 'Pendiente', 'Urgente', '2024-07-04', 4, 4),
('Solicitar peritaje ambiental', 'Estudio técnico de impacto en la zona', 'Pendiente', 'Alta', '2024-07-05', 5, 5);
INSERT INTO Tareas (Titulo, Descripcion, Estado, Prioridad, FechaLimite, UsuarioAsignadoID, CasoID)
VALUES
('Enviar notificación al cliente', 'Confirmar detalles por correo', 'Pendiente', 'Media', '2024-07-07', 1, 1),
('Actualizar expediente digital', 'Cargar documentos faltantes', 'En progreso', 'Alta', '2024-07-08', 2, 2),
('Solicitar antecedentes legales', 'Pedir historial en registro civil', 'Pendiente', 'Alta', '2024-07-09', 3, 3),
('Llamada de seguimiento', 'Contacto telefónico con cliente', 'Pendiente', 'Baja', '2024-07-10', 4, 4),
('Revisión de plazos procesales', 'Control de fechas importantes', 'Completada', 'Media', '2024-06-30', 5, 5),
('Agendar audiencia preliminar', 'Coordinar con juzgado', 'Pendiente', 'Alta', '2024-07-11', 1, 1),
('Gestionar firma electrónica', 'Generar documentos firmados', 'En progreso', 'Media', '2024-07-12', 2, 2),
('Subir actas notariales', 'Adjuntar actas al expediente', 'Pendiente', 'Urgente', '2024-07-13', 3, 3),
('Confirmar testigos', 'Llamar y registrar participación', 'Pendiente', 'Alta', '2024-07-14', 4, 4),
('Cerrar caso documental', 'Verificar cumplimiento de trámites', 'Pendiente', 'Media', '2024-07-15', 5, 5);

DECLARE @hoy DATETIME = GETDATE();

INSERT INTO Eventos (Titulo, Descripcion, Tipo, FechaInicio, FechaFin, Ubicacion, RecordatorioMinutos, CasoID, ClienteID, UsuarioCreadorID)
VALUES
('Audiencia familiar', 'Presentación de pruebas en el juzgado', 'Audiencia', @hoy, DATEADD(HOUR, 1, @hoy), 'Juzgado Familiar 4', 30, 1, 1, 1),
('Audiencia penal - Caso Torres', 'Revisión de estrategia legal', 'Reunión', @hoy, DATEADD(HOUR, 1, @hoy), 'Oficinas CDMX', 15, 2, 2, 2),
('Audiencia penal - Caso Torresr', 'Firma oficial de contrato revisado', 'Reunión', DATEADD(DAY, 1, @hoy), DATEADD(DAY , 3, DATEADD(HOUR, 2, @hoy)), 'Notaría 8', 20, 3, 3, 3);


DECLARE @hoy DATETIME = GETDATE();

INSERT INTO Eventos (Titulo, Descripcion, Tipo, FechaInicio, FechaFin,Ubicacion, RecordatorioMinutos, CasoID, ClienteID, UsuarioCreadorID
)
VALUES
('Audiencia penal - Caso Torres', 'Presentación de alegatos en sala penal', 'Audiencia', DATEADD(DAY, 0, @hoy), DATEADD(DAY, 0, DATEADD(HOUR, 1, @hoy)), 'Juzgado Penal 2A', 20, 4, 2, 1),
('Reunión interna de seguimiento', 'Revisión de avances del expediente activo', 'Reunión', DATEADD(DAY, 1, @hoy), DATEADD(DAY, 1, DATEADD(HOUR, 1, @hoy)), 'Sala Legal Norte', 15, NULL, NULL, 2),
('Entrega de peritaje contable', 'Recibir informe técnico solicitado', 'Tarea', DATEADD(DAY, 2, @hoy), DATEADD(DAY, 2, DATEADD(HOUR, 1, @hoy)), 23, 30, 1, 3),
('Audiencia oral - Caso Rivera', 'Declaración de testigos en materia civil', 'Audiencia', DATEADD(DAY, 3, @hoy), DATEADD(DAY, 3, DATEADD(HOUR, 1, @hoy)), 'Juzgado Civil 3B', 60, 5, 3, 4),
('Cita con cliente López', 'Firma de convenio previo a juicio', 'Reunión', DATEADD(DAY, 4, @hoy), DATEADD(DAY, 4, DATEADD(HOUR, 2, @hoy)), 'Sala 5', 15, NULL, 5, 5),
('Evaluación de estrategias', 'Análisis interno del caso Montes', 'Tarea', DATEADD(DAY, 5, @hoy), DATEADD(DAY, 5, DATEADD(HOUR, 1, @hoy)), NULL, 20, NULL, 6),
('Recordatorio: cierre de pruebas', 'Último día para presentar documentación adicional', 'Plazo', DATEADD(DAY, 6, @hoy), DATEADD(DAY, 6, DATEADD(HOUR, 2, @hoy)), NULL, NULL, NULL, 7),
('Audiencia intermedia - Caso Salgado', 'Conciliación de partes', 'Audiencia', DATEADD(DAY, 7, @hoy), DATEADD(DAY, 7, DATEADD(HOUR, 1, @hoy)), 'Juzgado Familiar 2C', 30, 6, 4, 8),
('Asesoría con pasante', 'Supervisión y revisión de tarea jurídica', 'Reunión', DATEADD(DAY, 8, @hoy), DATEADD(DAY, 8, DATEADD(HOUR, 1, @hoy)), 'Cubículo 7', NULL, NULL, NULL, 1),
('Preparación de carpeta de litigio', 'Organizar expediente para audiencia próxima', 'Tarea', DATEADD(DAY, 9, @hoy), DATEADD(DAY, 9, DATEADD(HOUR, 1, @hoy)), NULL, 25, 6, 2);











INSERT INTO Documentos (Nombre, Descripcion, Tipo, RutaArchivo, Tamano, CasoID, ClienteID, UsuarioSubioID, Etiquetas)
VALUES
('DemandaDivorcio.pdf', 'Documento inicial del caso de divorcio', 'Demanda', '/documentos/demanda_divorcio.pdf', 248576, 1, 1, 1, 'divorcio, familia'),
('PruebasLaborales.zip', 'Evidencias recolectadas para demanda laboral', 'Pruebas', '/documentos/pruebas_laborales.zip', 1048576, 2, 2, 2, 'pruebas, laboral'),
('ContratoRevisado.docx', 'Versión final del contrato aprobado', 'Contrato', '/documentos/contrato_revisado.docx', 512000, 3, 3, 3, 'corporativo, contrato');


select * from Usuarios;  
select * from Tareas;
 select * from Casos;

	    
	   EXEC sp_DesactivarUsuario @UsuarioID = 1;
	   EXEC sp_DesactivarUsuario @UsuarioID = 2;
	   EXEC sp_DesactivarUsuario @UsuarioID = 3;
	   EXEC sp_DesactivarUsuario @UsuarioID = 4;
	   EXEC sp_DesactivarUsuario @UsuarioID = 5;
	   EXEC sp_DesactivarUsuario @UsuarioID = 6;
	   EXEC sp_DesactivarUsuario @UsuarioID = 7;
	   EXEC sp_DesactivarUsuario @UsuarioID = 8;
	   EXEC sp_DesactivarUsuario @UsuarioID = 9;

