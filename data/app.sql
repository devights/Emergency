CREATE TABLE Incident (
	id CHAR(10) NOT NULL,
	start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	end TIMESTAMP NULL,
	location TINYTEXT NOT NULL,
	type_id INT NOT NULL,
	level INT NOT NULL,
	PRIMARY KEY (id)
); 

CREATE TABLE Vehicle (
	name VARCHAR(8) NOT NULL,
	type_id INT,
	PRIMARY KEY (name)
);

CREATE TABLE IncidentType (
	id INT(11) NOT NULL AUTO_INCREMENT,
	name TINYTEXT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Dispatch (
	vehicle_id INT NOT NULL,
	incident_id CHAR(10) NOT NULL,
	PRIMARY KEY (vehicle_id, incident_id)
);

CREATE TABLE Station (
	id INT AUTO_INCREMENT,
	name TINYTEXT NOT NULL,
	location TINYTEXT NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Assignment (
	vehicle_id INT NOT NULL,
	station_id INT NOT NULL,
	PRIMARY KEY (vehicle_id, station_id)
);

CREATE TABLE VehicleType (
	vehicle_id INT NOT NULL,
	name TINYTEXT NOT NULL,
	PRIMARY KEY (vehicle_id)
);
