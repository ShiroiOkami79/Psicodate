

CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL COMMENT 'Hash bcrypt de la contraseña',
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cuenta_activa BOOLEAN NOT NULL DEFAULT TRUE,
    rol ENUM('paciente', 'psicologo', 'admin') NOT NULL DEFAULT 'paciente',
    
    INDEX idx_email (email),
    INDEX idx_rol (rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Tabla principal de usuarios del sistema';



CREATE TABLE Psicologo (
    id_psicologo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    numero_colegiado VARCHAR(50) NOT NULL UNIQUE,
    especialidades VARCHAR(255) COMMENT 'Separadas por comas: Ansiedad, Depresión, Terapia de pareja',
    biografia TEXT,
    foto_perfil VARCHAR(255) COMMENT 'Ruta al archivo de imagen',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Datos profesionales de los psicólogos';



CREATE TABLE Servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion_minutos INT NOT NULL CHECK (duracion_minutos > 0),
    precio DECIMAL(6, 2) NOT NULL CHECK (precio >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Servicios ofrecidos (Terapia individual, de pareja, etc.)';



CREATE TABLE Cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL COMMENT 'Paciente que reserva',
    id_psicologo INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    codigo_reserva VARCHAR(20) NOT NULL UNIQUE,
    estado ENUM('pendiente', 'confirmada', 'completada', 'cancelada') NOT NULL DEFAULT 'pendiente',
    notas_clinicas TEXT COMMENT 'Solo visible para psicólogo',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cancelacion DATETIME,
    
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_psicologo) REFERENCES Psicologo(id_psicologo) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    INDEX idx_fecha_cita (fecha_cita),
    INDEX idx_estado (estado),
    INDEX idx_usuario (id_usuario),
    INDEX idx_psicologo (id_psicologo),
    INDEX idx_codigo_reserva (codigo_reserva)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Registro de citas entre pacientes y psicólogos';



CREATE TABLE Disponibilidad (
    id_disponibilidad INT AUTO_INCREMENT PRIMARY KEY,
    id_psicologo INT NOT NULL,
    dia_semana ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    
    FOREIGN KEY (id_psicologo) REFERENCES Psicologo(id_psicologo) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    INDEX idx_psicologo_dia (id_psicologo, dia_semana),
    INDEX idx_activo (activo),
    
    CHECK (hora_fin > hora_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Horario semanal de disponibilidad de psicólogos';



CREATE TABLE Bloqueo (
    id_bloqueo INT AUTO_INCREMENT PRIMARY KEY,
    id_psicologo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    motivo VARCHAR(255),
    
    FOREIGN KEY (id_psicologo) REFERENCES Psicologo(id_psicologo) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    INDEX idx_psicologo_fechas (id_psicologo, fecha_inicio, fecha_fin),
    
    CHECK (fecha_fin >= fecha_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Períodos de bloqueo para psicólogos (vacaciones, bajas)';



SHOW TABLES;
