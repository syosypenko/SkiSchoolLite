# Ski School Management Lite (Delphi 12)

Small desktop app for managing a ski school with SQLite and VCL forms.

<img width="454" height="502" alt="Screenshot 2026-02-07 at 01 17 57" src="https://github.com/user-attachments/assets/cef6e12a-21dc-448d-88f1-aa5f3e9dc630" />


## Overview
Manage:
- Courses and schedules
- Instructors
- Students
- Bookings (student enrollments)
- Assignments (instructors to courses)
- Basic reports

## Tech Stack
- Object Pascal (Delphi 12)
- SQLite (FireDAC)
- VCL desktop forms
- DataModule-based data access

## Database Entities
- Instructors (ID, Name, Email, Phone)
- Courses (ID, Name, StartDate, EndDate, Level)
- Students (ID, Name, Email, Phone)
- Bookings (BookingID, CourseID, StudentID, BookingDate)
- Assignments (AssignmentID, CourseID, InstructorID)

Relationships:
- One Course → Many Students (via Bookings)
- One Instructor → Many Courses (via Assignments)

## Core Features
- Course CRUD with schedule and level
- Student CRUD and enrolled list
- Instructor CRUD and course assignments
- Booking system with duplicate prevention
- Reports: students per course, instructor workload
- Validation and basic error handling

## Open
- Project file: SkiSchoolLiteDelphi12.dpr

## Structure
- src: data layer and entities
- forms: VCL forms (.pas/.dfm)

## Key Files
- src/DatabaseModule.pas
- src/Entities.pas
- forms/MainForm.pas

## Database
- Auto-creates SkiSchool.db beside the EXE on first run.

## Build/Run
- Build and run from Delphi 12 IDE.
  <img width="1010" height="640" alt="Screenshot 2026-02-07 at 01 19 14" src="https://github.com/user-attachments/assets/ffbb1992-eea1-4313-9c1c-8e6ba17e15ae" />

