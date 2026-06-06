PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

DROP TABLE IF EXISTS pagos;
DROP TABLE IF EXISTS ordenes_servicios;
DROP TABLE IF EXISTS ordenes;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS servicios;
DROP TABLE IF EXISTS vehiculos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    telefono TEXT NOT NULL UNIQUE,
    correo TEXT,
    direccion TEXT,
    activo INTEGER NOT NULL DEFAULT 1,
    fecha_registro TEXT NOT NULL DEFAULT (datetime('now','localtime')),
    CHECK (activo IN (0,1))
);

CREATE TABLE vehiculos (
    id_vehiculo INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    placa TEXT NOT NULL UNIQUE,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    anio INTEGER NOT NULL,
    color TEXT NOT NULL,
    tipo TEXT NOT NULL DEFAULT 'Sedán',
    activo INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE servicios (
    id_servicio INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT,
    precio REAL NOT NULL,
    duracion_minutos INTEGER NOT NULL DEFAULT 30,
    activo INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE empleados (
    id_empleado INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    telefono TEXT NOT NULL,
    puesto TEXT NOT NULL DEFAULT 'Lavador',
    activo INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE ordenes (
    id_orden INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    id_vehiculo INTEGER NOT NULL,
    id_empleado INTEGER,
    estado TEXT NOT NULL DEFAULT 'Pendiente',
    fecha_entrada TEXT NOT NULL DEFAULT (datetime('now','localtime')),
    fecha_salida TEXT,
    observaciones TEXT,
    motivo_cancelacion TEXT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE ordenes_servicios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_orden INTEGER NOT NULL,
    id_servicio INTEGER NOT NULL,
    precio_cobrado REAL NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

CREATE TABLE pagos (
    id_pago INTEGER PRIMARY KEY AUTOINCREMENT,
    id_orden INTEGER NOT NULL UNIQUE,
    monto_total REAL NOT NULL,
    metodo_pago TEXT NOT NULL DEFAULT 'Efectivo',
    fecha_pago TEXT NOT NULL DEFAULT (datetime('now','localtime')),
    referencia TEXT,
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden)
);
