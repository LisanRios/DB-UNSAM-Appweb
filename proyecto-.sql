-- Crear Schema
CREATE SCHEMA IF NOT EXISTS proyecto_UNSAM_CAECE;

-- Seleccionar el esquema
USE proyecto_UNSAM_CAECE;

-- Crear tabla Tipos_Aula
CREATE TABLE IF NOT EXISTS Tipos_Aula (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla Tipos_Permiso
CREATE TABLE IF NOT EXISTS Tipos_Permiso (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla Personas
CREATE TABLE IF NOT EXISTS Personas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    rol ENUM('ALUMNO', 'PROFESOR', 'ADMINISTRADOR') NOT NULL DEFAULT 'ALUMNO'
);

-- Crear tabla Permisos con referencia a Tipos_Permiso y Personas
CREATE TABLE IF NOT EXISTS Permisos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    persona_id BIGINT,
    tipo_permiso_id BIGINT,
    FOREIGN KEY (persona_id) REFERENCES Personas(id),
    FOREIGN KEY (tipo_permiso_id) REFERENCES Tipos_Permiso(id)
);

-- Crear tabla Aulas con referencia a Tipos_Aula
CREATE TABLE IF NOT EXISTS Aulas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo_aula_id BIGINT,
    FOREIGN KEY (tipo_aula_id) REFERENCES Tipos_Aula(id)
);

-- Crear tabla Carreras
CREATE TABLE IF NOT EXISTS Carreras (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla Asignaturas
CREATE TABLE IF NOT EXISTS Asignaturas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla intermedia para relación N:M entre Carreras y Asignaturas
CREATE TABLE IF NOT EXISTS Carreras_Asignaturas (
    carrera_id BIGINT NOT NULL,
    asignatura_id BIGINT NOT NULL,
    PRIMARY KEY (carrera_id, asignatura_id),
    FOREIGN KEY (carrera_id) REFERENCES Carreras(id) ON DELETE CASCADE,
    FOREIGN KEY (asignatura_id) REFERENCES Asignaturas(id) ON DELETE CASCADE
);

-- Crear tabla Profesores_Asignaturas para asociar personas (profesores) con asignaturas
CREATE TABLE IF NOT EXISTS Profesores_Asignaturas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    persona_id BIGINT,
    asignatura_id BIGINT,
    FOREIGN KEY (persona_id) REFERENCES Personas(id),
    FOREIGN KEY (asignatura_id) REFERENCES Asignaturas(id)
);

-- Crear tabla Horarios
CREATE TABLE IF NOT EXISTS Horarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    dia ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    aula_id BIGINT,
    asignatura_id BIGINT,
    FOREIGN KEY (aula_id) REFERENCES Aulas(id),
    FOREIGN KEY (asignatura_id) REFERENCES Asignaturas(id)
);

-- Crear tabla Ocupacion_Aulas para seguimiento de ocupación de aulas
CREATE TABLE IF NOT EXISTS Ocupacion_Aulas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    aula_id BIGINT,
    horario_id BIGINT,
    fecha DATE NOT NULL,
    FOREIGN KEY (aula_id) REFERENCES Aulas(id),
    FOREIGN KEY (horario_id) REFERENCES Horarios(id)
);

-- Crear tabla Reservas para manejar las reservas de aulas
CREATE TABLE IF NOT EXISTS Reservas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    aula_id BIGINT NOT NULL,
    horario_id BIGINT NOT NULL,
    profesor_id BIGINT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (aula_id) REFERENCES Aulas(id),
    FOREIGN KEY (horario_id) REFERENCES Horarios(id),
    FOREIGN KEY (profesor_id) REFERENCES Personas(id),
    UNIQUE (aula_id, horario_id, fecha)
);

-- Datos iniciales de ejemplo

-- Insertar tipos de permisos
INSERT INTO Tipos_Permiso (nombre) VALUES ('Profesor'), ('Alumno'), ('Administrador');

-- Insertar tipos de aula
INSERT INTO Tipos_Aula (nombre) VALUES ('Laboratorio'), ('Sala Informática'), ('Aula Estándar');

-- Insertar carreras
INSERT INTO Carreras (nombre) VALUES ('TPI'), ('TRI'), ('Ingeniería'), ('Biología'), ('Matemáticas');

-- Insertar asignaturas
INSERT INTO Asignaturas (nombre) VALUES ('Programación'), ('Redes'), ('Cálculo'), ('Física'), ('Biología General');

-- Insertar relación carreras-asignaturas
INSERT INTO Carreras_Asignaturas (carrera_id, asignatura_id) VALUES
    (1, 1), (1, 2), (2, 2), (2, 3), (3, 3), (3, 4), (4, 5), (5, 3), (5, 4);

-- Insertar personas
INSERT INTO Personas (nombre, apellido, email, rol) VALUES 
    ('Juan', 'Pérez', 'juan.perez@unsam.edu.ar', 'PROFESOR'),
    ('Ana', 'López', 'ana.lopez@unsam.edu.ar', 'PROFESOR'),
    ('Carlos', 'Gómez', 'carlos.gomez@unsam.edu.ar', 'ALUMNO'),
    ('Laura', 'Martínez', 'laura.martinez@unsam.edu.ar', 'ALUMNO'),
    ('María', 'Fernández', 'maria.fernandez@unsam.edu.ar', 'ADMINISTRADOR');

-- Insertar permisos para personas
INSERT INTO Permisos (persona_id, tipo_permiso_id) VALUES (1, 1), (2, 1), (3, 2), (4, 2), (5, 3);

-- Insertar aulas
INSERT INTO Aulas (nombre, tipo_aula_id) VALUES 
    ('Aula 101', 3), 
    ('Laboratorio A', 1), 
    ('Sala Informática 1', 2), 
    ('Aula 102', 3), 
    ('Laboratorio B', 1);

-- Insertar asignaciones de profesores a asignaturas
INSERT INTO Profesores_Asignaturas (persona_id, asignatura_id) VALUES 
    (1, 1), 
    (1, 2), 
    (2, 3), 
    (2, 4), 
    (2, 5);

-- Insertar horarios
INSERT INTO Horarios (dia, hora_inicio, hora_fin, aula_id, asignatura_id) VALUES 
    ('Lunes', '09:00:00', '11:00:00', 1, 1),
    ('Martes', '10:00:00', '12:00:00', 2, 2),
    ('Miércoles', '14:00:00', '16:00:00', 3, 3),
    ('Jueves', '08:00:00', '10:00:00', 4, 4),
    ('Viernes', '13:00:00', '15:00:00', 5, 5);

-- Insertar ocupación de aulas
INSERT INTO Ocupacion_Aulas (aula_id, horario_id, fecha) VALUES 
    (1, 1, '2024-11-01'), 
    (2, 2, '2024-11-02'), 
    (3, 3, '2024-11-03'), 
    (4, 4, '2024-11-04'), 
    (5, 5, '2024-11-05');

-- Insertar reservas de aulas
INSERT INTO Reservas (aula_id, horario_id, profesor_id, fecha) VALUES 
    (1, 1, 1, '2024-11-06'), 
    (2, 2, 1, '2024-11-07'), 
    (3, 3, 2, '2024-11-08'), 
    (4, 4, 2, '2024-11-09'), 
    (5, 5, 1, '2024-11-10');
