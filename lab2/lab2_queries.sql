-- 1
SELECT * FROM equipment;

-- 2
SELECT * FROM employees;

-- 3
SELECT * FROM equipment_write_offs;

-- 4
UPDATE employees
SET position = 'Старший кладовщик'
WHERE employee_id = 2;
SELECT * FROM employees;

-- 5
DELETE FROM equipment
WHERE equipment_id = 6;
SELECT * FROM equipment;

-- 6
INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES (99, 1, 'Поломка', '2025-03-01', 'АКТ-0040', '2025-03-01');

-- 7
DELETE FROM employees
WHERE employee_id = 1;

-- 8
INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES (2, 1, 'Поломка', '2025-03-01', 'АКТ-0012', '2025-03-01');

-- 9
INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES (2, 1, 'Поломка', '2025-03-10', 'АКТ-0041', '2025-03-01');

-- 10
INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES (2, 3, 'Поломка', '2022-01-10', 'АКТ-0042', '2022-01-10');

-- 11
INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES (2, 4, 'Поломка', '2022-12-01', 'АКТ-0043', '2022-12-01');
