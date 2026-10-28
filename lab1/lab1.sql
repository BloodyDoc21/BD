CREATE TABLE equipment (
    equipment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    equipment_name VARCHAR(150) NOT NULL,
    equipment_type VARCHAR(100) NOT NULL,
    rental_entry_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE employees (
    employee_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE equipment_write_offs (
    write_off_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    equipment_id INT NOT NULL
        REFERENCES equipment(equipment_id) ON DELETE RESTRICT,
    employee_id INT NOT NULL
        REFERENCES employees(employee_id) ON DELETE RESTRICT,
    reason TEXT NOT NULL,
    write_off_date DATE NOT NULL DEFAULT CURRENT_DATE,
    document_number VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO equipment (equipment_name, equipment_type, rental_entry_date)
VALUES
('Перфоратор Bosch GBH 2-28', 'Электроинструмент', '2023-04-10'),
('Виброплита Champion PC9045F', 'Строительная техника', '2022-08-15'),
('Моющий пылесос Karcher Puzzi 10/1', 'Клининговое оборудование',
 '2023-01-20');

INSERT INTO employees (last_name, first_name, patronymic, position,
                       hire_date)
VALUES
('Смирнов', 'Алексей', 'Сергеевич', 'Инженер по обслуживанию',
 '2021-03-01'),
('Кузнецова', 'Ольга', 'Игоревна', 'Кладовщик', '2022-05-12');

INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES
(1, 1, 'Критический износ двигателя, ремонту не подлежит',
 '2024-02-14', 'АКТ-0012', '2024-02-14');
