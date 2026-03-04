-- Tabla departamento
CREATE TABLE departamento (
    codigo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla ciudad
-- Un departamento tiene muchas ciudades (1:N)
-- Una ciudad pertenece a un solo departamento (N:1)
CREATE TABLE ciudad (
    codigo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo_departamento INT NOT NULL,
    CONSTRAINT fk_ciudad_departamento
        FOREIGN KEY (codigo_departamento)
        REFERENCES departamento(codigo)
);

-- Tabla propietario
CREATE TABLE propietario (
    identificacion INT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(150) -- opcional
);

-- Tabla propietario_telefono
-- Un propietario puede tener muchos teléfonos (1:N)
-- Atributo multivaluado, se separa en tabla propia
CREATE TABLE propietario_telefono (
    id SERIAL PRIMARY KEY,
    identificacion_propietario INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    CONSTRAINT fk_prop_tel_prop
        FOREIGN KEY (identificacion_propietario)
        REFERENCES propietario(identificacion)
);

-- Tabla vivienda
-- Un propietario puede tener muchas viviendas (1:N)
-- Una vivienda pertenece a un solo propietario (N:1)
-- Una vivienda está ubicada en una sola ciudad (N:1)
-- Una ciudad puede tener muchas viviendas (1:N)
CREATE TABLE vivienda (
    codigo SERIAL PRIMARY KEY,
    calle VARCHAR(100) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    cant_habitantes INT,
    descripcion TEXT,
    identificacion_propietario INT NOT NULL,
    codigo_ciudad INT NOT NULL,
    CONSTRAINT fk_vivienda_propietario
        FOREIGN KEY (identificacion_propietario)
        REFERENCES propietario(identificacion),
    CONSTRAINT fk_vivienda_ciudad
        FOREIGN KEY (codigo_ciudad)
        REFERENCES ciudad(codigo)
);

-- Tabla inquilino
CREATE TABLE inquilino (
    identificacion INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL
);

-- Tabla inquilino_telefono
-- Un inquilino puede tener muchos teléfonos (1:N)
-- Atributo multivaluado, se separa en tabla propia
CREATE TABLE inquilino_telefono (
    id SERIAL PRIMARY KEY,
    identificacion_inquilino INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    CONSTRAINT fk_inq_tel_inq
        FOREIGN KEY (identificacion_inquilino)
        REFERENCES inquilino(identificacion)
);

-- Tabla arriendo
-- Una vivienda puede tener muchos arriendos a lo largo del tiempo (1:N)
-- Un arriendo pertenece a una sola vivienda (N:1)
CREATE TABLE arriendo (
    codigo SERIAL PRIMARY KEY,
    f_inicio DATE NOT NULL,
    f_fin DATE, -- opcional, si no tiene fecha fin el arriendo sigue activo
    valor_mensual NUMERIC(12,2) NOT NULL,
    codigo_vivienda INT NOT NULL,
    CONSTRAINT fk_arriendo_vivienda
        FOREIGN KEY (codigo_vivienda)
        REFERENCES vivienda(codigo)
);

-- Tabla inquilino_arriendo
-- Relacion N:M entre inquilino y arriendo  (Muchos a muchos)
-- Un arriendo puede tener varios inquilinos (familia)
-- Un inquilino puede haber participado en varios arriendos (arriendo en diferentes viviendas)
-- Se resuelve con tabla intermedia usando ambas PKs como PK compuesta
CREATE TABLE inquilino_arriendo (
    identificacion_inquilino INT NOT NULL,
    codigo_arriendo INT NOT NULL,
    PRIMARY KEY (identificacion_inquilino, codigo_arriendo), --PK Compuesta
    CONSTRAINT fk_inq_arr_inquilino
        FOREIGN KEY (identificacion_inquilino)
        REFERENCES inquilino(identificacion),
    CONSTRAINT fk_inq_arr_arriendo
        FOREIGN KEY (codigo_arriendo)
        REFERENCES arriendo(codigo)
);