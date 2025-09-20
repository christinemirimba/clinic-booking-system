-- ============================================================
-- Clinic Booking System: Relational Schema for MySQL
-- Author: Christine Kwamboka Mirimba
-- Date: 2025-09-20
-- Description: Full-featured schema for managing clinic operations
-- ============================================================

-- ------------------------------------------------------------
-- DATABASE INITIALIZATION
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS clinic_booking_db;

CREATE DATABASE clinic_booking_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE clinic_booking_db;

-- ------------------------------------------------------------
-- TABLE: Roles
-- ------------------------------------------------------------
CREATE TABLE roles (
  id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255),
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Users
-- ------------------------------------------------------------
CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  role_id TINYINT UNSIGNED NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(30),
  password_hash VARCHAR(255) NOT NULL, -- Use bcrypt or SHA-256 in app layer
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  CONSTRAINT fk_users_role FOREIGN KEY (role_id)
    REFERENCES roles(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Patients
-- ------------------------------------------------------------
CREATE TABLE patients (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL UNIQUE,
  dob DATE,
  gender ENUM('Male','Female','Other'),
  blood_type ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
  allergies TEXT,
  emergency_contact VARCHAR(100),
  PRIMARY KEY (id),
  CONSTRAINT fk_patients_user FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Doctors
-- ------------------------------------------------------------
CREATE TABLE doctors (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL UNIQUE,
  specialization VARCHAR(100) NOT NULL,
  license_number VARCHAR(100) NOT NULL UNIQUE,
  years_experience INT DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT fk_doctors_user FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Departments
-- ------------------------------------------------------------
CREATE TABLE departments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Doctor_Department (Many-to-Many)
-- ------------------------------------------------------------
CREATE TABLE doctor_department (
  doctor_id BIGINT UNSIGNED NOT NULL,
  department_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (doctor_id, department_id),
  CONSTRAINT fk_dd_doctor FOREIGN KEY (doctor_id)
    REFERENCES doctors(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_dd_department FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Appointments
-- ------------------------------------------------------------
CREATE TABLE appointments (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  patient_id BIGINT UNSIGNED NOT NULL,
  doctor_id BIGINT UNSIGNED NOT NULL,
  appointment_date DATETIME NOT NULL,
  status ENUM('Scheduled','Completed','Cancelled','No-Show') NOT NULL DEFAULT 'Scheduled',
  reason VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id)
    REFERENCES patients(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id)
    REFERENCES doctors(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Prescriptions
-- ------------------------------------------------------------
CREATE TABLE prescriptions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  appointment_id BIGINT UNSIGNED NOT NULL,
  medication VARCHAR(255) NOT NULL,
  dosage VARCHAR(100) NOT NULL,
  instructions TEXT,
  prescribed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_prescriptions_appointment FOREIGN KEY (appointment_id)
    REFERENCES appointments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Medical Records
-- ------------------------------------------------------------
CREATE TABLE medical_records (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  patient_id BIGINT UNSIGNED NOT NULL,
  doctor_id BIGINT UNSIGNED, -- Nullable for ON DELETE SET NULL
  diagnosis TEXT NOT NULL,
  treatment TEXT,
  record_date DATE NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_medical_records_patient FOREIGN KEY (patient_id)
    REFERENCES patients(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_medical_records_doctor FOREIGN KEY (doctor_id)
    REFERENCES doctors(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLE: Billing
-- ------------------------------------------------------------
CREATE TABLE billing (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  appointment_id BIGINT UNSIGNED NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  status ENUM('Pending','Paid','Cancelled','Refunded') NOT NULL DEFAULT 'Pending',
  payment_method ENUM('Cash','Card','Insurance','Mpesa') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_billing_appointment FOREIGN KEY (appointment_id)
    REFERENCES appointments(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- INDEXES FOR PERFORMANCE
-- ------------------------------------------------------------
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_users_email ON users(email);

-- ------------------------------------------------------------
-- SEED DATA
-- ------------------------------------------------------------

-- Roles
INSERT INTO roles (id, name, description) VALUES
  (1, 'patient', 'Patient role'),
  (2, 'doctor', 'Doctor role'),
  (3, 'admin', 'Administrator role');

-- Doctor user
INSERT INTO users (role_id, first_name, last_name, email, phone, password_hash, is_active)
VALUES (2, 'John', 'Doe', 'johndoe@clinic.com', '0712345678', 'hashed_john_password', 1);

INSERT INTO doctors (user_id, specialization, license_number, years_experience)
VALUES (LAST_INSERT_ID(), 'General Practitioner', 'DOC12345', 10);

-- Patient user
INSERT INTO users (role_id, first_name, last_name, email, phone, password_hash, is_active)
VALUES (1, 'Jane', 'Smith', 'janesmith@example.com', '0798765432', 'hashed_jane_password', 1);

INSERT INTO patients (user_id, dob, gender, blood_type, allergies, emergency_contact)
VALUES (LAST_INSERT_ID(), '1990-05-12', 'Female', 'O+', 'Penicillin', 'Mary Smith 0711222333');
