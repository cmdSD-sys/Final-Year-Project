import os
import sys
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

def set_cell_background(cell, fill_hex):
    """Set the background color of a table cell."""
    tcPr = cell._tc.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    """Set inner padding of a table cell in dxa (1/20 of a pt)."""
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        node = OxmlElement(f'w:{m}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

def add_callout(doc, text, title="NOTE", color_hex="0B6A90"):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    tbl.columns[0].width = Inches(6.5)
    
    cell = tbl.cell(0, 0)
    set_cell_background(cell, "F0F7FA")
    set_cell_margins(cell, top=140, bottom=140, left=200, right=200)
    
    # Left border highlight
    tcPr = cell._tc.get_or_add_tcPr()
    borders = parse_xml(
        f'<w:tcBorders {nsdecls("w")}>'
        f'<w:left w:val="single" w:sz="24" w:space="0" w:color="{color_hex}"/>'
        f'<w:top w:val="none"/>'
        f'<w:right w:val="none"/>'
        f'<w:bottom w:val="none"/>'
        f'</w:tcBorders>'
    )
    tcPr.append(borders)
    
    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(0)
    p.paragraph_format.space_after = Pt(2)
    run_t = p.add_run(f"[{title}] ")
    run_t.bold = True
    run_t.font.name = "Calibri"
    run_t.font.size = Pt(10)
    run_t.font.color.rgb = RGBColor.from_string(color_hex)
    
    run_b = p.add_run(text)
    run_b.font.name = "Calibri"
    run_b.font.size = Pt(9.5)
    run_b.font.color.rgb = RGBColor(0x22, 0x33, 0x3E)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(4)

def format_table(table, header_bg="0B6A90", row_alt_bg="F6FAFC"):
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = False
    
    # Header styling
    for cell in table.rows[0].cells:
        set_cell_background(cell, header_bg)
        set_cell_margins(cell, top=120, bottom=120, left=140, right=140)
        cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
        for p in cell.paragraphs:
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            p.paragraph_format.space_before = Pt(2)
            p.paragraph_format.space_after = Pt(2)
            for r in p.runs:
                r.bold = True
                r.font.name = "Calibri"
                r.font.size = Pt(9.5)
                r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
                
    # Data rows styling
    for i, row in enumerate(table.rows[1:], start=1):
        bg = row_alt_bg if i % 2 == 0 else "FFFFFF"
        for cell in row.cells:
            set_cell_background(cell, bg)
            set_cell_margins(cell, top=100, bottom=100, left=140, right=140)
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            for p in cell.paragraphs:
                p.paragraph_format.space_before = Pt(2)
                p.paragraph_format.space_after = Pt(2)
                for r in p.runs:
                    r.font.name = "Calibri"
                    r.font.size = Pt(9)
                    r.font.color.rgb = RGBColor(0x22, 0x33, 0x3E)

def main():
    doc = Document()
    
    # Configure 0.8 inch margins
    for section in doc.sections:
        section.top_margin = Inches(0.8)
        section.bottom_margin = Inches(0.8)
        section.left_margin = Inches(0.8)
        section.right_margin = Inches(0.8)
        
    brand_blue = RGBColor(0x0B, 0x6A, 0x90)
    dark_ink = RGBColor(0x1B, 0x2A, 0x32)
    slate_muted = RGBColor(0x5A, 0x6E, 0x78)
    
    # ----------------------------------------------------
    # DOCUMENT COVER / TITLE
    # ----------------------------------------------------
    p_inst = doc.add_paragraph()
    p_inst.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_inst = p_inst.add_run("K. K. Wagh Polytechnic, Nashik")
    r_inst.bold = True
    r_inst.font.name = "Arial"
    r_inst.font.size = Pt(14)
    r_inst.font.color.rgb = brand_blue
    
    p_title = doc.add_paragraph()
    p_title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_title = p_title.add_run("BACKEND REQUIREMENT SPECIFICATION (BRS)\nMSBTE Academic Monitoring System")
    r_title.bold = True
    r_title.font.name = "Arial"
    r_title.font.size = Pt(20)
    r_title.font.color.rgb = dark_ink
    p_title.paragraph_format.space_after = Pt(4)
    
    p_sub = doc.add_paragraph()
    p_sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_sub = p_sub.add_run("A Developer-Friendly Guide to Database Schema, Storage Architecture, REST API Contracts & Frontend Wiring")
    r_sub.italic = True
    r_sub.font.name = "Calibri"
    r_sub.font.size = Pt(11)
    r_sub.font.color.rgb = slate_muted
    p_sub.paragraph_format.space_after = Pt(16)
    
    # Meta table
    meta_tbl = doc.add_table(rows=4, cols=2)
    meta_tbl.columns[0].width = Inches(2.2)
    meta_tbl.columns[1].width = Inches(4.3)
    meta_data = [
        ("Document Version", "1.0.0 (Production Release Specification)"),
        ("Current Scope", "Computer Technology Department (CM) + Institute Admin"),
        ("Primary Target Database", "PostgreSQL 15+ (Relational + JSONB)"),
        ("Object Storage System", "MinIO (Self-Hosted S3) or Local Disk File Service"),
    ]
    for row_idx, (k, v) in enumerate(meta_data):
        meta_tbl.cell(row_idx, 0).paragraphs[0].add_run(k).bold = True
        meta_tbl.cell(row_idx, 1).paragraphs[0].add_run(v)
    format_table(meta_tbl, header_bg="1B2A32", row_alt_bg="F0F4F7")
    
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 1: EXECUTIVE SUMMARY & ARCHITECTURE
    # ----------------------------------------------------
    h1 = doc.add_heading(level=1)
    r = h1.add_run("1. Executive Summary & Architecture Overview")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "This document provides the definitive technical specification for building the backend services "
        "required by the KK Wagh Polytechnic Internal Monitoring and MSBTE Compliance Web Application. "
        "The frontend has been constructed using Flutter Web with declarative client-side routing, "
        "allowing immediate offline operation via in-memory mock services. This specification details "
        "how to build the accompanying RESTful API, PostgreSQL database schema, and Object Storage "
        "system so the frontend can be wired to the live backend seamlessly."
    )
    
    add_callout(
        doc,
        "The Flutter Web frontend already contains complete DTO serialization models and an ApiService abstraction. "
        "Once this backend is built, simply setting 'AppConfig.useRemoteBackend = true' in 'lib/config/app_config.dart' "
        "and supplying the base URL will instantly connect the entire application.",
        title="INSTANT WIRING GUARANTEE"
    )
    
    # Architecture Summary Table
    arch_tbl = doc.add_table(rows=6, cols=3)
    arch_tbl.columns[0].width = Inches(1.8)
    arch_tbl.columns[1].width = Inches(2.2)
    arch_tbl.columns[2].width = Inches(2.5)
    
    headers = ["Layer", "Recommended Technology", "Purpose in System"]
    for i, h in enumerate(headers):
        arch_tbl.cell(0, i).paragraphs[0].add_run(h)
        
    arch_rows = [
        ("Frontend Client", "Flutter Web 3.x + GoRouter", "Single-Page Web Application, URL navigation (/cm-report/admission, etc.)"),
        ("API Gateway / Server", "Node.js (Express/NestJS) OR Python (FastAPI)", "RESTful endpoints, JWT validation, multipart file handling"),
        ("Relational Database", "PostgreSQL 15+ / 16", "ACID transactions, relational keys, JSONB for dynamic table rows"),
        ("Object / File Storage", "MinIO (Self-hosted) or AWS S3", "NBA PDF certificates (up to 2MB), Excel rosters, avatars, reports"),
        ("Security & Auth", "JWT (Bearer Token) + bcrypt", "Role-Based Access Control (Super Admin, Admin, Department User)"),
    ]
    for r_idx, row_vals in enumerate(arch_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            arch_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(arch_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 2: DATABASE RECOMMENDATION & JUSTIFICATION
    # ----------------------------------------------------
    h2 = doc.add_heading(level=1)
    r = h2.add_run("2. Database Recommendation & In-Depth Justification")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "We strongly recommend PostgreSQL 15+ as the primary database management system for this project. "
        "Below are the critical technical reasons why PostgreSQL outperforms alternatives (e.g., MySQL or pure MongoDB) "
        "for academic monitoring compliance:"
    )
    
    reasons = [
        ("Strict Relational Integrity (Foreign Keys):", 
         " Academic monitoring forms require strict linkages between departments, faculty staff, curriculum courses, "
         "semesters, and audit submissions. PostgreSQL guarantees cascade integrity so orphaned academic records never occur."),
        ("Hybrid Relational + JSONB Power:", 
         " The 11 MSBTE screens feature both strict relational attributes (intake capacity, dates, yes/no flags) and "
         "dynamic tabular data (custom laboratory equipment lists, elective subjects, faculty publications). "
         "PostgreSQL's binary JSON (JSONB) allows indexing and querying structured JSON directly inside SQL queries."),
        ("ACID Compliance & Multi-User Concurrency:", 
         " When faculty members and department heads simultaneously update attendance, syllabus progress, and test marks, "
         "PostgreSQL's Multi-Version Concurrency Control (MVCC) prevents dirty reads and write locks."),
        ("Zero Licensing Cost & Enterprise Reliability:", 
         " Open-source, permissive license, easily deployable in on-premises Linux servers or Docker containers on college premises."),
    ]
    for title_text, body_text in reasons:
        p = doc.add_paragraph(style='List Bullet')
        r_t = p.add_run(title_text)
        r_t.bold = True
        p.add_run(body_text)
        
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 3: FILE STORAGE SYSTEM SPECIFICATION
    # ----------------------------------------------------
    h3 = doc.add_heading(level=1)
    r = h3.add_run("3. File Storage System Requirements")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "The frontend application interacts with several types of binary files that must NOT be stored in SQL columns. "
        "A dedicated file storage service is required with UUID-based path hashing and virus/mime validation."
    )
    
    storage_tbl = doc.add_table(rows=5, cols=4)
    storage_tbl.columns[0].width = Inches(1.8)
    storage_tbl.columns[1].width = Inches(1.2)
    storage_tbl.columns[2].width = Inches(1.5)
    storage_tbl.columns[3].width = Inches(2.0)
    
    st_headers = ["File Category", "Max File Size", "Allowed Formats", "Storage Path / Bucket"]
    for i, h in enumerate(st_headers):
        storage_tbl.cell(0, i).paragraphs[0].add_run(h)
        
    st_rows = [
        ("NBA Accreditation Certificate", "5 MB (2MB typical)", "PDF only (application/pdf)", "/certificates/nba/{dept_code}/{uuid}.pdf"),
        ("Faculty & Curriculum Master Sheets", "10 MB", "Excel (.xlsx, .xls)", "/imports/excel/{academic_year}/{uuid}.xlsx"),
        ("User Profile Avatars", "2 MB", "JPEG, PNG, WebP", "/avatars/{user_id}/{uuid}.png"),
        ("Generated Reports Archive (PDF/Docx)", "25 MB", "PDF (.pdf), Word (.docx)", "/reports/{dept_code}/{academic_year}/{uuid}.pdf"),
    ]
    for r_idx, row_vals in enumerate(st_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            storage_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(storage_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(8)
    
    doc.add_paragraph(
        "Recommended Storage Solutions:\n"
        "1. MinIO (Recommended for College LAN / On-Premise): Open-source high-performance object storage with an S3-compatible API. "
        "Allows generating presigned upload/download URLs.\n"
        "2. Node.js/Python Disk Storage: If object storage is unavailable, store files in a secured directory outside the web root (e.g., /var/kkwagh_storage/) "
        "and serve files through an authenticated streaming controller (/api/files/download/{file_id})."
    )
    
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 4: AUTHENTICATION & ACCESS CONTROL (RBAC)
    # ----------------------------------------------------
    h4 = doc.add_heading(level=1)
    r = h4.add_run("4. Authentication & Role-Based Access Control (RBAC)")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "The system enforces JSON Web Token (JWT) Bearer authentication for all endpoints except public health check and login."
    )
    
    # Roles table
    roles_tbl = doc.add_table(rows=4, cols=3)
    roles_tbl.columns[0].width = Inches(1.5)
    roles_tbl.columns[1].width = Inches(2.2)
    roles_tbl.columns[2].width = Inches(2.8)
    
    r_headers = ["Role Identifier", "Intended Persona", "Permissions & Capabilities"]
    for i, h in enumerate(r_headers):
        roles_tbl.cell(0, i).paragraphs[0].add_run(h)
        
    r_rows = [
        ("SUPER_ADMIN", "Principal / System Admin", "Full CRUD on all users, promote/demote roles, system configuration, all departments access."),
        ("ADMIN", "HOD (Head of Dept) / Academic Co-ordinator", "Manage department faculty, import master Excel sheets, review submissions, export PDF/Docx, edit CM reports."),
        ("USER", "Department Faculty / Staff", "Edit and save all 11 MSBTE screens for CM department, export preview PDF, submit draft records."),
    ]
    for r_idx, row_vals in enumerate(r_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            roles_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(roles_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(8)
    
    add_callout(
        doc,
        "As per current requirements, the system is focused on Computer Technology (CM) Department. "
        "Both 'Admin' and 'User' roles currently have equal editing permissions for all 11 CM Report screens, "
        "allowing collaborative data entry without permission barriers.",
        title="COLLABORATIVE CM PERMISSION RULE"
    )
    
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 5: DATABASE SCHEMAS (ALL 11 SCREENS + CORE)
    # ----------------------------------------------------
    h5 = doc.add_heading(level=1)
    r = h5.add_run("5. Complete Database Schemas (11 MSBTE Screens)")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "Below is the exact relational schema mapping required to persist all data entered in the frontend."
    )
    
    # Core tables
    doc.add_heading("5.1 Core Entity Tables (Users, Departments, Academic Sessions)", level=2)
    
    core_tbl = doc.add_table(rows=7, cols=3)
    core_tbl.columns[0].width = Inches(1.8)
    core_tbl.columns[1].width = Inches(1.5)
    core_tbl.columns[2].width = Inches(3.2)
    for i, h in enumerate(["Column Name", "Data Type", "Description / Constraints"]):
        core_tbl.cell(0, i).paragraphs[0].add_run(h)
    core_rows = [
        ("id", "UUID / BIGSERIAL", "PRIMARY KEY"),
        ("email", "VARCHAR(255)", "UNIQUE NOT NULL (e.g., admin@kkwagh.edu.in)"),
        ("password_hash", "VARCHAR(255)", "NOT NULL (bcrypt / argon2)"),
        ("full_name", "VARCHAR(150)", "NOT NULL (e.g., Prof. A. R. Patil)"),
        ("role", "VARCHAR(30)", "ENUM: 'SUPER_ADMIN', 'ADMIN', 'USER'"),
        ("department_code", "VARCHAR(10)", "FOREIGN KEY -> departments(code) (e.g. 'CM')"),
    ]
    for r_idx, row_vals in enumerate(core_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            core_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(core_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(10)
    
    # Screen 1 Schema
    doc.add_heading("5.2 Screen 1: Department Information (department_info)", level=2)
    doc.add_paragraph("Table name: cm_department_info")
    
    s1_tbl = doc.add_table(rows=12, cols=3)
    s1_tbl.columns[0].width = Inches(2.2)
    s1_tbl.columns[1].width = Inches(1.3)
    s1_tbl.columns[2].width = Inches(3.0)
    for i, h in enumerate(["Field Name", "Type", "MSBTE Field Mapping"]):
        s1_tbl.cell(0, i).paragraphs[0].add_run(h)
    s1_rows = [
        ("academic_year", "VARCHAR(15)", "e.g. '2024-25'"),
        ("vision_mission_prepared", "VARCHAR(5)", "'Yes' or 'No'"),
        ("vision_mission_date", "DATE / VARCHAR(20)", "Date of approval (e.g., 2024-06-15)"),
        ("nba_accreditation", "VARCHAR(5)", "'Yes' or 'No'"),
        ("nba_valid_from", "DATE / VARCHAR(20)", "Accreditation valid start date"),
        ("nba_valid_till", "DATE / VARCHAR(20)", "Accreditation valid expiry date"),
        ("nba_certificate_url", "TEXT", "Stored URL or UUID of uploaded NBA PDF"),
        ("internal_audit_conducted", "VARCHAR(5)", "'Yes' or 'No' (Every 6 months)"),
        ("internal_audit_date", "DATE / VARCHAR(20)", "Date of internal academic audit"),
        ("smart_classroom_available", "VARCHAR(5)", "'Yes' or 'No' (At least one)"),
        ("biometric_attendance", "VARCHAR(5)", "'Yes' or 'No'"),
    ]
    for r_idx, row_vals in enumerate(s1_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            s1_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(s1_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(10)
    
    # Screen 2 to 11 Summaries
    doc.add_heading("5.3 Screens 2 to 11 Schema Specifications", level=2)
    
    screens_summary_tbl = doc.add_table(rows=11, cols=3)
    screens_summary_tbl.columns[0].width = Inches(1.5)
    screens_summary_tbl.columns[1].width = Inches(2.2)
    screens_summary_tbl.columns[2].width = Inches(2.8)
    for i, h in enumerate(["Screen No & Name", "Recommended Table Name", "Core Fields Stored"]):
        screens_summary_tbl.cell(0, i).paragraphs[0].add_run(h)
        
    scr_rows = [
        ("2. Admission", "cm_admissions", "academic_year, sanctioned_intake, first_year_admitted, direct_second_year, cutoff_merit, caste_category_distribution (JSONB)"),
        ("3. Faculty Strength", "cm_faculty_strength", "academic_year, total_posts_sanctioned, professors_count, associate_count, assistant_count, student_faculty_ratio"),
        ("4. Faculty Profile", "cm_faculty_profiles", "faculty_id, full_name, designation, qualification, teaching_exp_years, industry_exp_years, doj, papers_published, fdp_attended"),
        ("5. Laboratory", "cm_laboratories", "lab_name, room_number, carpet_area_sqm, equipment_list (JSONB), total_investment_inr, lab_incharge_name, technical_assistant"),
        ("6. Curriculum", "cm_curriculum_analysis", "subject_code, subject_name, semester (1-6), scheme ('I'/'K'), weekly_th_pr_hours, credits, syllabus_covered_pct, industrial_visits"),
        ("7. Attendance", "cm_student_attendance", "class_division, subject_code, avg_theory_attendance_pct, avg_practical_attendance_pct, defaulter_students_count, remedial_action"),
        ("8. Result Analysis", "cm_result_analysis", "exam_session ('W24'/'S25'), semester, appeared_count, passed_count, passing_pct, distinction_count, first_class_count"),
        ("9. Resources", "cm_learning_resources", "library_titles_count, library_volumes_count, national_journals, international_journals, digital_library_subscriptions, pcs_count"),
        ("10. Co-Curricular", "cm_co_curricular_activities", "activity_type (Workshop/Guest Lecture/Visit), title, date_conducted, resource_person_details, students_participated_count"),
        ("11. Any Other Info", "cm_any_other_info", "academic_year, mou_collaborations (JSONB), industry_awards, patents_filed, student_achievements, best_practices_summary"),
    ]
    for r_idx, row_vals in enumerate(scr_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            screens_summary_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(screens_summary_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 6: REST API CONTRACT SPECIFICATIONS
    # ----------------------------------------------------
    h6 = doc.add_heading(level=1)
    r = h6.add_run("6. REST API Endpoint Specifications")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "All endpoints use standard HTTP status codes: 200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, "
        "403 Forbidden, 404 Not Found, 500 Internal Server Error. Responses must be returned as application/json."
    )
    
    api_tbl = doc.add_table(rows=14, cols=4)
    api_tbl.columns[0].width = Inches(0.9)
    api_tbl.columns[1].width = Inches(2.2)
    api_tbl.columns[2].width = Inches(1.1)
    api_tbl.columns[3].width = Inches(2.3)
    for i, h in enumerate(["Method", "Endpoint Path", "Auth", "Purpose / Payload"]):
        api_tbl.cell(0, i).paragraphs[0].add_run(h)
        
    api_rows = [
        ("POST", "/api/auth/login", "Public", "Email & password -> returns {token, user}"),
        ("POST", "/api/auth/refresh", "Refresh", "Exchange refresh token for new access token"),
        ("GET", "/api/auth/me", "Bearer", "Get current user profile & permissions"),
        ("POST", "/api/files/upload", "Bearer", "Multipart upload for NBA PDF (<=5MB), returns {fileUrl, fileId}"),
        ("GET", "/api/files/{file_id}", "Bearer/Signed", "Stream binary file contents or redirect to MinIO"),
        ("GET", "/api/cm-report", "Bearer", "Fetch complete CM report (all 11 screens state)"),
        ("PUT", "/api/cm-report/dept-info", "Bearer", "Save Screen 1 Department Information"),
        ("PUT", "/api/cm-report/{tab_slug}", "Bearer", "Save specific screen (admission, faculty, lab, etc.)"),
        ("POST", "/api/catalog/import-excel", "Admin", "Upload Master Excel (.xlsx) for faculty & subjects"),
        ("GET", "/api/catalog/faculties", "Bearer", "List active faculty members for department"),
        ("GET", "/api/catalog/courses", "Bearer", "List curriculum courses by scheme & semester"),
        ("GET", "/api/submissions", "Bearer", "List past monitoring submissions"),
        ("POST", "/api/submissions", "Bearer", "Submit new IIM monitoring submission"),
    ]
    for r_idx, row_vals in enumerate(api_rows, start=1):
        for c_idx, val in enumerate(row_vals):
            api_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(api_tbl)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(10)
    
    # Sample JSON Payload
    doc.add_heading("6.1 Sample Screen 1 JSON Payload (PUT /api/cm-report/dept-info)", level=2)
    p_code = doc.add_paragraph()
    r_code = p_code.add_run(
        "{\n"
        '  "departmentName": "Computer Technology",\n'
        '  "academicYear": "2024-25",\n'
        '  "visionMissionPrepared": "Yes",\n'
        '  "visionMissionApprovalDate": "2024-06-15",\n'
        '  "nbaAccreditation": "Yes",\n'
        '  "nbaValidFrom": "2022-07-01",\n'
        '  "nbaValidTill": "2025-06-30",\n'
        '  "nbaCertificateFileName": "NBA_Accreditation_CM_2022_2025.pdf",\n'
        '  "nbaCertificateFileUrl": "/api/files/d3b07384-d113-4632-a567-27b2a9d80c34.pdf",\n'
        '  "internalAuditOnce6Months": "Yes",\n'
        '  "internalAuditDate": "2024-11-20",\n'
        '  "smartClassroomAvailable": "Yes",\n'
        '  "biometricAttendanceAvailable": "Yes",\n'
        '  "techJournalsCount": 6\n'
        "}"
    )
    r_code.font.name = "Courier New"
    r_code.font.size = Pt(8.5)
    r_code.font.color.rgb = RGBColor(0x0B, 0x6A, 0x90)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 7: FRONTEND WIRING & DECOUPLING ARCHITECTURE
    # ----------------------------------------------------
    h7 = doc.add_heading(level=1)
    r = h7.add_run("7. Frontend Decoupling & How To Wire the Backend")
    r.font.color.rgb = brand_blue
    
    doc.add_paragraph(
        "The frontend has been purposely constructed with clean architectural separation. "
        "It currently runs in standalone mode using 'AppConfig.useRemoteBackend = false'."
    )
    
    wiring_steps = [
        ("Step 1 - Deploy API and Set Base URL:", 
         " Deploy your backend service (e.g. at 'https://api.monitoring.kkwagh.edu.in' or 'http://localhost:8080')."),
        ("Step 2 - Enable Remote Backend in Flutter Config:", 
         " In 'lib/config/app_config.dart', flip the boolean flag:\n"
         "   static const bool useRemoteBackend = true;\n"
         "   static const String remoteApiBaseUrl = 'https://api.monitoring.kkwagh.edu.in';"),
        ("Step 3 - Token Handling:", 
         " The AppState service will automatically forward credentials to POST /api/auth/login, "
         "store the returned JWT token, and attach 'Authorization: Bearer <token>' to all subsequent requests."),
        ("Step 4 - CORS Configuration (Essential for Flutter Web):", 
         " Your backend API must include CORS headers allowing origin of the Flutter Web client (e.g., Access-Control-Allow-Origin: * or specific domain), "
         "with allowed headers: 'Authorization, Content-Type, Accept'."),
    ]
    for s_title, s_desc in wiring_steps:
        p = doc.add_paragraph(style='List Bullet')
        p.add_run(s_title).bold = True
        p.add_run(s_desc)
        
    doc.add_paragraph().paragraph_format.space_after = Pt(14)
    
    # ----------------------------------------------------
    # SECTION 8: DEVELOPER CHECKLIST
    # ----------------------------------------------------
    h8 = doc.add_heading(level=1)
    r = h8.add_run("8. Backend Developer Action Checklist")
    r.font.color.rgb = brand_blue
    
    checklist = [
        ("[ ] 1. Database Provisioning", "Install PostgreSQL 15+ and create database 'kkwagh_monitoring_db'."),
        ("[ ] 2. Run DDL Migrations", "Execute table migration scripts for users, departments, and 11 cm_* tables."),
        ("[ ] 3. MinIO / File Service Setup", "Configure storage bucket 'kkwagh-files' with max upload limit 10MB."),
        ("[ ] 4. Implement Auth & JWT", "Create /api/auth/login, /api/auth/me with bcrypt password hashing."),
        ("[ ] 5. Implement CM Report Endpoints", "Create GET /api/cm-report and PUT /api/cm-report/{tab} handlers."),
        ("[ ] 6. Implement File Upload Endpoint", "Create POST /api/files/upload accepting multipart form-data for PDFs."),
        ("[ ] 7. Enable CORS", "Allow requests from Flutter Web client port (e.g., localhost:3000 / port 5000)."),
        ("[ ] 8. Seed Default Accounts", "Seed 'admin@kkwagh.edu.in' (role ADMIN) and 'user@kkwagh.edu.in' (role USER)."),
        ("[ ] 9. Flip Frontend Toggle", "Change useRemoteBackend to true in lib/config/app_config.dart and verify live sync!"),
    ]
    
    chk_tbl = doc.add_table(rows=10, cols=2)
    chk_tbl.columns[0].width = Inches(2.5)
    chk_tbl.columns[1].width = Inches(4.0)
    for i, h in enumerate(["Checklist Task", "Implementation Goal"]):
        chk_tbl.cell(0, i).paragraphs[0].add_run(h)
    for r_idx, row_vals in enumerate(checklist, start=1):
        for c_idx, val in enumerate(row_vals):
            chk_tbl.cell(r_idx, c_idx).paragraphs[0].add_run(val)
    format_table(chk_tbl, header_bg="1B2A32", row_alt_bg="F0F4F7")
    
    output_path = r"d:\SoftCrowd\Projects\FuckVTC\final_project\Backend_Requirement_Specification.docx"
    doc.save(output_path)
    print(f"Document successfully created at: {output_path}")

if __name__ == "__main__":
    main()
