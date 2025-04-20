-- 1. Функция поиска по шаблону
DROP FUNCTION find_contacts(TEXT);

CREATE OR REPLACE FUNCTION find_contacts(pattern TEXT)
RETURNS TABLE(id INTEGER, name VARCHAR(100), phone VARCHAR(20))
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM phonebook
    WHERE phonebook.name ILIKE '%' || pattern || '%'
       OR phonebook.phone ILIKE '%' || pattern || '%';
END;
$$;



-- 2. Процедура вставки или обновления по имени
CREATE OR REPLACE PROCEDURE insert_or_update_user(user_name TEXT, user_phone TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM phonebook WHERE name = user_name) THEN
        UPDATE phonebook SET phone = user_phone WHERE name = user_name;
    ELSE
        INSERT INTO phonebook(name, phone) VALUES (user_name, user_phone);
    END IF;
END;
$$;

-- 3. Процедура массовой вставки из JSON
CREATE OR REPLACE PROCEDURE insert_many_users(user_list JSON)
LANGUAGE plpgsql AS $$
DECLARE
    rec JSON;
    user_name TEXT;
    user_phone TEXT;
    invalid_entries TEXT[] := ARRAY[]::TEXT[];
BEGIN
    FOR rec IN SELECT * FROM json_array_elements(user_list)
    LOOP
        user_name := rec->>'name';
        user_phone := rec->>'phone';

        IF user_phone ~ '^\+?[0-9]{10,15}$' THEN
            CALL insert_or_update_user(user_name, user_phone);
        ELSE
            invalid_entries := array_append(invalid_entries, user_name || ' - ' || user_phone);
        END IF;
    END LOOP;

    RAISE NOTICE 'Invalid entries: %', invalid_entries;
END;
$$;

-- 4. Функция постраничного вывода (pagination)
CREATE OR REPLACE FUNCTION get_contacts_paginated(limit_num INT, offset_num INT)
RETURNS TABLE(id INTEGER, name TEXT, phone TEXT)
LANGUAGE SQL AS $$
    SELECT * FROM phonebook
    ORDER BY id
    LIMIT limit_num OFFSET offset_num;
$$;

-- 5. Процедура удаления по имени или номеру
CREATE OR REPLACE PROCEDURE delete_by_name_or_phone(value TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM phonebook WHERE name = value OR phone = value;
END;
$$;


-- Проверка процедур

SELECT * FROM find_contacts('Timur');

CALL insert_or_update_user('Yasmina', '+77001112233');

CALL insert_many_users(
  '[{"name": "Aliya", "phone": "+77009998877"},
    {"name": "BadGuy", "phone": "+77002224567"},
    {"name": "Timur", "phone": "+77001234567"}]'::json
);


SELECT * FROM get_contacts_paginated(2, 0);  -- первые 2 записи
SELECT * FROM get_contacts_paginated(2, 2);  -- следующие 2 записи

CALL delete_by_name_or_phone('yasmina');
CALL delete_by_name_or_phone('+77009998877');


SELECT * FROM public.phonebook


