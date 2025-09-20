# 🏥 Clinic Booking System

A **production-grade relational database** built with **MySQL** to manage core operations in a modern clinic. This system supports patient registration, doctor management, appointment scheduling, prescriptions, medical records, billing, and role-based access control.

Developed by **Christine Kwamboka Mirimba** as part of the **Week 8 Assignment – Database Management Systems**.

---

## 📌 Features

- 👤 **User Roles**: Patients, Doctors, Admins  
- 🧾 **Appointments**: Patients can book with doctors  
- 💊 **Prescriptions**: Doctors issue medications and instructions  
- 🩺 **Medical Records**: Track diagnoses and treatments  
- 🏥 **Departments**: Doctors belong to multiple departments  
- 💳 **Billing**: Linked to appointments with multiple payment methods  
- 🔐 **Constraints**: Proper use of `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `ENUM`  
- 📈 **Indexes**: Optimized queries for performance  
- 🕒 **Timestamps**: Track creation and updates across entities  

---

## 🗄️ Database Schema

### 📦 Core Tables

| Table Name           | Description                                      |
|----------------------|--------------------------------------------------|
| `roles`              | Defines user roles (admin, doctor, patient)      |
| `users`              | Generic user accounts with login credentials     |
| `patients`           | Medical profile and emergency contact            |
| `doctors`            | Specialization, license, experience              |
| `departments`        | Medical departments (e.g., Cardiology)           |
| `doctor_department`  | Many-to-many link between doctors and departments|
| `appointments`       | Scheduled visits between patients and doctors    |
| `prescriptions`      | Medications prescribed during appointments       |
| `medical_records`    | Historical diagnoses and treatments              |
| `billing`            | Payment records linked to appointments           |

### 🔗 Relationships

- **One-to-One** → `users ↔ patients`, `users ↔ doctors`  
- **One-to-Many** → `patients → appointments`, `doctors → appointments`  
- **Many-to-Many** → `doctors ↔ departments`  

---

## 📂 File Structure

📦 clinic-booking-system 
                        ┣ 📜 clinic_booking.sql # Production-ready MySQL schema 
                        ┣ 📜 README.md # Project documentation 

---

## 🚀 Getting Started

### 1️⃣ Clone Repository
```bash
git clone https://github.com/christinemirimba/clinic-booking-system.git
cd clinic-booking-system

### 2️⃣ Import Database in MySQL
sql
SOURCE week8_clinic_booking.sql;
### 3️⃣ Verify Setup
sql
SHOW DATABASES;
USE clinic_booking_db;
SHOW TABLES;

---

## 🧪 Example Queries
** 📅 Book an Appointment
sql
INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason)
VALUES (1, 1, '2025-09-22 10:00:00', 'General Checkup');

** 📋 List Upcoming Appointments for a Doctor
sql
SELECT a.id, p.user_id, u.first_name, u.last_name, a.appointment_date
FROM appointments a
JOIN patients p ON a.patient_id = p.id
JOIN users u ON p.user_id = u.id
WHERE a.doctor_id = 1 AND a.status = 'Scheduled'
ORDER BY a.appointment_date;
** 💰 Get Unpaid Bills
sql
SELECT b.id, u.first_name, u.last_name, b.amount, b.status
FROM billing b
JOIN appointments a ON b.appointment_id = a.id
JOIN patients p ON a.patient_id = p.id
JOIN users u ON p.user_id = u.id
WHERE b.status = 'Pending';

---

##  👩‍💻 Author
Christine Kwamboka Mirimba 🎓 Bachelor of Science in Computer Science 📧 christine@example.com

---

## 📜 License
This project is for educational purposes as part of coursework. Feel free to use, modify, and extend for learning or portfolio development.
