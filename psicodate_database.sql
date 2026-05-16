
DROP DATABASE IF EXISTS psicodate;
CREATE DATABASE psicodate;
USE psicodate;

-- Tabla de usuarios
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    cuenta_activa BOOLEAN DEFAULT TRUE,
    rol ENUM('paciente', 'psicologo', 'admin') DEFAULT 'paciente'
);

-- Tabla de psicólogos
CREATE TABLE Psicologo (
    id_psicologo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    numero_colegiado VARCHAR(50) NOT NULL UNIQUE,
    especialidades VARCHAR(255),
    biografia TEXT,
    foto_perfil VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
);

-- Tabla de servicios
CREATE TABLE Servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion_minutos INT NOT NULL,
    precio DECIMAL(6, 2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de citas
CREATE TABLE Cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_psicologo INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    codigo_reserva VARCHAR(20) NOT NULL UNIQUE,
    estado ENUM('pendiente', 'confirmada', 'completada', 'cancelada') DEFAULT 'pendiente',
    notas_clinicas TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_cancelacion DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_psicologo) REFERENCES Psicologo(id_psicologo),
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
);

-- Tabla de disponibilidad de psicólogos
CREATE TABLE Disponibilidad (
    id_disponibilidad INT AUTO_INCREMENT PRIMARY KEY,
    id_psicologo INT NOT NULL,
    dia_semana ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_psicologo) REFERENCES Psicologo(id_psicologo) ON DELETE CASCADE
);

-- Tabla de bloqueos (vacaciones, bajas)
CREATE TABLE Bloqueo (
    id_bloqueo INT AUTO_INCREMENT PRIMARY KEY,
    id_psicologo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    motivo VARCHAR(255),
    FOREIGN KEY (id_psicologo) REFERENCES Psicologo(id_psicologo) ON DELETE CASCADE
);