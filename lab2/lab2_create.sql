DROP TABLE IF EXISTS equipment_write_offs, employees, equipment;

CREATE TABLE equipment (
    equipment_id INT GENERATED ALWAYS AS IDENTITY,
    equipment_name VARCHAR(150) NOT NULL,
    equipment_type VARCHAR(100) NOT NULL,
    rental_entry_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_equipment PRIMARY KEY (equipment_id),
    CONSTRAINT chk_equipment_entry_date
        CHECK (rental_entry_date <= CURRENT_DATE)
);

CREATE TABLE employees (
    employee_id INT GENERATED ALWAYS AS IDENTITY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_employees PRIMARY KEY (employee_id),
    CONSTRAINT chk_employees_hire_date
        CHECK (hire_date <= CURRENT_DATE)
);

CREATE TABLE equipment_write_offs (
    write_off_id INT GENERATED ALWAYS AS IDENTITY,
    equipment_id INT NOT NULL,
    employee_id INT NOT NULL,
    reason TEXT NOT NULL,
    write_off_date DATE NOT NULL DEFAULT CURRENT_DATE,
    document_number VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT pk_write_offs PRIMARY KEY (write_off_id),
    CONSTRAINT fk_write_offs_equipment FOREIGN KEY (equipment_id)
        REFERENCES equipment (equipment_id) ON DELETE RESTRICT,
    CONSTRAINT fk_write_offs_employee FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id) ON DELETE RESTRICT,
    CONSTRAINT uq_write_offs_document UNIQUE (document_number),
    CONSTRAINT uq_write_offs_equipment UNIQUE (equipment_id),
    CONSTRAINT chk_write_offs_registration
        CHECK (registration_date >= write_off_date)
);

CREATE OR REPLACE FUNCTION check_write_off_dates()
RETURNS TRIGGER AS $$
DECLARE
    entry_date DATE;
    hire DATE;
BEGIN
    SELECT rental_entry_date INTO entry_date
    FROM equipment
    WHERE equipment_id = NEW.equipment_id;

    IF NEW.write_off_date < entry_date THEN
        RAISE EXCEPTION
            'Дата списания % раньше даты поступления в прокат %',
            NEW.write_off_date, entry_date;
    END IF;

    SELECT hire_date INTO hire
    FROM employees
    WHERE employee_id = NEW.employee_id;

    IF NEW.write_off_date < hire THEN
        RAISE EXCEPTION
            'Сотрудник принят на работу % - позже даты списания %',
            hire, NEW.write_off_date;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_write_off_dates
BEFORE INSERT OR UPDATE ON equipment_write_offs
FOR EACH ROW
EXECUTE FUNCTION check_write_off_dates();

INSERT INTO equipment (equipment_name, equipment_type, rental_entry_date)
VALUES
('Перфоратор Bosch GBH 2-28', 'Электроинструмент', '2023-04-10'),
('Виброплита Champion PC9045F', 'Строительная техника', '2022-08-15'),
('Моющий пылесос Karcher Puzzi 10/1', 'Клининговое оборудование',
 '2023-01-20'),
('Бетономешалка Зубр БМ-160', 'Строительная техника', '2021-06-03'),
('Шуруповерт Makita DF333DWYE', 'Электроинструмент', '2023-09-18'),
('Генератор Huter DY4000L', 'Энергооборудование', '2024-03-05');

INSERT INTO employees (last_name, first_name, patronymic, position,
                       hire_date)
VALUES
('Смирнов', 'Алексей', 'Сергеевич', 'Инженер по обслуживанию',
 '2021-03-01'),
('Кузнецова', 'Ольга', 'Игоревна', 'Кладовщик', '2022-05-12'),
('Волков', 'Дмитрий', 'Андреевич', 'Начальник пункта проката',
 '2019-11-20'),
('Морозова', 'Анна', 'Петровна', 'Менеджер по прокату', '2023-02-06');

INSERT INTO equipment_write_offs (equipment_id, employee_id, reason,
    write_off_date, document_number, registration_date)
VALUES
(1, 1, 'Критический износ двигателя, ремонту не подлежит',
 '2024-02-14', 'АКТ-0012', '2024-02-14'),
(4, 3, 'Трещина барабана, восстановление нецелесообразно',
 '2024-05-22', 'АКТ-0018', '2024-05-23'),
(3, 2, 'Неисправность насоса после длительной эксплуатации',
 '2024-09-10', 'АКТ-0025', '2024-09-11'),
(5, 4, 'Утеряно клиентом, компенсация получена',
 '2025-01-27', 'АКТ-0031', '2025-01-28');
