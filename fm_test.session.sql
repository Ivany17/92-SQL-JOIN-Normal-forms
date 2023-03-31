/* Извлечь все заказы, где стоимость каждого выше среднего */
-- узнать стоимость каждого заказа
SELECT pto."order.id", sum(p."price"*pto."quantity")
FROM "phones_to_orders" AS pto
    JOIN "phones" as p ON pto."phone.id">p."id"
GROUP BY pto."order.id";

-- найти среднее значение
SELECT avg("sumOrder"."cost")
FROM (
    SELECT pto."order.id", sum(p."price"*pto."quantity") AS "cost"
    FROM "phones_to_orders" AS pto
        JOIN "phones" as p ON pto."phone.id">p."id"
    GROUP BY pto."order.id"
) AS "sumOrder";

-- найти выше среднего
SELECT "sumOrder".*
FROM (
    SELECT pto."order.id", sum(p."price"*pto."quantity") AS "cost"
    FROM "phones_to_orders" AS pto
        JOIN "phones" as p ON pto."phone.id">p."id"
    GROUP BY pto."order.id"
) AS "sumOrder"
WHERE "sumOrder"."cost" > (
    SELECT avg("sumOrder"."cost")
FROM (
        SELECT pto."order.id", sum(p."price"*pto."quantity") AS "cost"
        FROM "phones_to_orders" AS pto
            JOIN "phones" as p ON pto."phone.id">p."id"
        GROUP BY pto."order.id"
    ) AS "sumOrder"
);

-- итог
WITH "sumOrder" AS (
    SELECT pto."order.id", sum(p."price"*pto."quantity") AS "cost"
    FROM "phones_to_orders" AS pto
        JOIN "phones" as p ON pto."phone.id">p."id"
    GROUP BY pto."order.id";
)
SELECT "sumOrder".*
FROM "sumOrder"
WHERE "sumOrder"."cost" > (
    SELECT avg("sumOrder"."cost")
    FROM "sumOrder"
);


/* Извлечь всех пользователей,у которых количество заказов выше среднего */
-- количество заказов каждого пользователя
SELECT count (o."id") AS "amount", u.*
FROM "users" AS u
    JOIN "orders" AS o ON u."id"=o."userId"
GROUP BY u."id"
-- найти среднее количество
SELECT ao.*
FROM "amount_order" AS ao
WHERE ao."amount" > (
    SELECT avg(ao."amount")
    FROM "amount_order" AS ao
)
-- привести к результату
WITH "amount_order" AS (
    SELECT count (o."id") AS "amount", u.*
    FROM "users" AS u
        JOIN "orders" AS o ON u."id"=o."userId"
    GROUP BY u."id"
)
SELECT ao.*
FROM "amount_order" AS ao
WHERE ao."amount" > (
    SELECT avg(ao."amount")
    FROM "amount_order" AS ao
)
ORDER BY ao."amount" DESC;


/* 1 Normal Form */
CREATE TABLE table1(
    p1 VARCHAR(64),
    p2 INT,
    PRIMARY KEY(p1, p2)
);

/* 2 Normal Form */
CREATE TABLE "positions"(
    "name" VARCHAR(64) PRIMARY KEY,
    "doesHaveTheCar"
)
CREATE TABLE "workers"(
    id serial PRIMARY KEY,
    "name",
    "department",
    "occupation" VARCHAR(64) REFERENCES "positions"."occupation",
)
INSERT INTO "positions" ("name", "doesHaveTheCar")
VALUES ('teacher', false),
('student', false),
('driver', true);
INSERT INTO "workers" ("name", "occupation")
VALUES ('Ivan', 'Teacher'),
('Ann', 'HR'),
('Nazar', 'Driver');

/* 3 Normal Form */
CREATE TABLE "positions"(
    "name" VARCHAR(64) PRIMARY KEY,
    "doesHaveTheCar"
);
CREATE TABLE "departments"(
    "name" VARCHAR(64) PRIMARY KEY,
    "phone" VARCHAR(64)
);
CREATE TABLE "workers"(
    id serial PRIMARY KEY,
    "name",
    "department" VARCHAR(64) REFERENCES "departments"."name",
    "occupation" VARCHAR(64) REFERENCES "positions"."name",
)

/* BCNF (Нормальная Форма Бойса-Кодда) */
CREATE TABLE "students"(id serial PRIMARY KEY);
CREATE TABLE "subjects"(id serial PRIMARY KEY);
CREATE TABLE "teachers"(id serial PRIMARY KEY,
"subjectId" INT REFERENCES "subjects"."id");

CREATE TABLE "students_to_teachers"(
    "student_id" INT REFERENCES "students".id,
    "teacher_id" INT REFERENCES "teachers".id,
    PRIMARY KEY("student_id", "teacher_id")
);

INSERT INTO "students_to_teachers_to_subjects"
VALUES
(1,1),
(1,2),
(2,1),
(2,2)