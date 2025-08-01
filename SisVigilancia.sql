-- ========================
-- SISTEMA DE VIGILANCIA
-- ========================

-- CATÁLOGOS GENERALES

CREATE TABLE TipoServicio (
  id_tipo_servicio INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT
);

CREATE TABLE TipoCliente (
  id_tipo_cliente INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50)
);

CREATE TABLE EstadoServicio (
  id_estado INT PRIMARY KEY AUTO_INCREMENT,
  nombre_estado VARCHAR(50)
);

CREATE TABLE Sexo (
  id_sexo INT PRIMARY KEY AUTO_INCREMENT,
  descripcion VARCHAR(10) -- Masculino, Femenino
);

CREATE TABLE TipoEquipo (
  id_tipo_equipo INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50)
);

CREATE TABLE TipoEvento (
  id_tipo_evento INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) -- Uso arma, uso gas, traslado cliente, etc.
);

CREATE TABLE EstadoEquipo (
  id_estado_equipo INT PRIMARY KEY AUTO_INCREMENT,
  descripcion VARCHAR(50) -- Asignado, Dañado, Devuelto, etc.
);

CREATE TABLE TipoAccion (
  id_tipo_accion INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) -- Disparo de arma, uso de gas pimienta, linterna, etc.
);

-- CLIENTES Y SERVICIOS

CREATE TABLE Cliente (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100),
  id_tipo_cliente INT,
  direccion TEXT,
  FOREIGN KEY (id_tipo_cliente) REFERENCES TipoCliente(id_tipo_cliente)
);

CREATE TABLE Servicio (
  id_servicio INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente INT,
  id_tipo_servicio INT,
  id_estado INT,
  fecha_inicio DATE,
  fecha_fin DATE,
  lugar TEXT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_tipo_servicio) REFERENCES TipoServicio(id_tipo_servicio),
  FOREIGN KEY (id_estado) REFERENCES EstadoServicio(id_estado)
);

-- VIGILANTES Y REQUISITOS

CREATE TABLE Vigilante (
  id_vigilante INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100),
  id_sexo INT,
  tiene_licencia_armas BOOLEAN,
  activo BOOLEAN,
  FOREIGN KEY (id_sexo) REFERENCES Sexo(id_sexo)
);

CREATE TABLE RequisitoCliente (
  id_requisito INT PRIMARY KEY AUTO_INCREMENT,
  id_servicio INT,
  id_sexo_preferido INT,
  requiere_licencia_armas BOOLEAN,
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
  FOREIGN KEY (id_sexo_preferido) REFERENCES Sexo(id_sexo)
);

CREATE TABLE AsignacionVigilante (
  id_asignacion INT PRIMARY KEY AUTO_INCREMENT,
  id_servicio INT,
  id_vigilante INT,
  fecha_asignacion DATE,
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
  FOREIGN KEY (id_vigilante) REFERENCES Vigilante(id_vigilante)
);

-- EQUIPOS Y MATERIALES

CREATE TABLE Equipo (
  id_equipo INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100),
  id_tipo_equipo INT,
  FOREIGN KEY (id_tipo_equipo) REFERENCES TipoEquipo(id_tipo_equipo)
);

CREATE TABLE AsignacionEquipo (
  id_asignacion_equipo INT PRIMARY KEY AUTO_INCREMENT,
  id_equipo INT,
  id_vigilante INT,
  fecha_asignacion DATETIME,
  fecha_devolucion DATETIME,
  id_estado_equipo INT,
  FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo),
  FOREIGN KEY (id_vigilante) REFERENCES Vigilante(id_vigilante),
  FOREIGN KEY (id_estado_equipo) REFERENCES EstadoEquipo(id_estado_equipo)
);

-- EVENTOS, ACCIONES Y AUDITORÍA

CREATE TABLE EventoServicio (
  id_evento INT PRIMARY KEY AUTO_INCREMENT,
  id_servicio INT,
  id_vigilante INT,
  fecha_evento DATETIME,
  id_tipo_evento INT,
  descripcion TEXT,
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
  FOREIGN KEY (id_vigilante) REFERENCES Vigilante(id_vigilante),
  FOREIGN KEY (id_tipo_evento) REFERENCES TipoEvento(id_tipo_evento)
);

CREATE TABLE AccionEvento (
  id_accion_evento INT PRIMARY KEY AUTO_INCREMENT,
  id_evento INT,
  id_tipo_accion INT,
  id_equipo INT,
  cantidad_usos INT,
  descripcion TEXT,
  FOREIGN KEY (id_evento) REFERENCES EventoServicio(id_evento),
  FOREIGN KEY (id_tipo_accion) REFERENCES TipoAccion(id_tipo_accion),
  FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo)
);

CREATE TABLE AuditoriaUsoEquipo (
  id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
  id_evento INT,
  id_equipo INT,
  observacion TEXT,
  FOREIGN KEY (id_evento) REFERENCES EventoServicio(id_evento),
  FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo)
);
