CREATE TABLE "cars" (
	"id" INT NOT NULL,
	"engine_capacity" VARCHAR2(128) NOT NULL,
	"engine_power" VARCHAR2(128) NOT NULL,
	"fuel_type_id" VARCHAR2(128) NOT NULL,
	"price" VARCHAR2(128) NOT NULL,
	"gearbox_id" VARCHAR2(128) NOT NULL,
	"body_id" VARCHAR2(128) NOT NULL,
	"drive_id" VARCHAR2(128) NOT NULL,
	"mileage" VARCHAR2(128) NOT NULL,
	"wheel_id" VARCHAR2(128) NOT NULL,
	"car_state_id" VARCHAR2(128) NOT NULL,
	"customs" VARCHAR2(128) NOT NULL,
	"color_id" VARCHAR2(128) NOT NULL,
	"year" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "fuel_type" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "gearbox_type" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "body_type" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "drive_type" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "wheel_type" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "car_state" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "colors" (
	"id" INT NOT NULL,
	"name" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "source_data" (
	"FIELD1" INT NOT NULL,
	"Unnamed_0" INT NOT NULL,
	"price" VARCHAR2(128) NOT NULL,
	"Двигатель" VARCHAR2(128) NOT NULL,
	"Коробка" VARCHAR2(128) NOT NULL,
	"Кузов" VARCHAR2(128) NOT NULL,
	"Привод" VARCHAR2(128) NOT NULL,
	"Пробег" VARCHAR2(128) NOT NULL,
	"Руль" VARCHAR2(128) NOT NULL,
	"Состояние" VARCHAR2(128) NOT NULL,
	"Таможня" VARCHAR2(128) NOT NULL,
	"Цвет" VARCHAR2(128) NOT NULL,
	"год_выпуска" VARCHAR2(128) NOT NULL);


/
CREATE TABLE "source_data ALTERED" (
	"id" INT NOT NULL,
	"Unnamed_0" INT NOT NULL,
	"price" VARCHAR2(128) NOT NULL,
	"engine" VARCHAR2(128) NOT NULL,
	"gearbox" VARCHAR2(128) NOT NULL,
	"body" VARCHAR2(128) NOT NULL,
	"drive" VARCHAR2(128) NOT NULL,
	"mileage" VARCHAR2(128) NOT NULL,
	"wheel" VARCHAR2(128) NOT NULL,
	"state" VARCHAR2(128) NOT NULL,
	"custom" VARCHAR2(128) NOT NULL,
	"color" VARCHAR2(128) NOT NULL,
	"year" VARCHAR2(128) NOT NULL);


/
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk0" FOREIGN KEY ("fuel_type_id") REFERENCES "fuel_type"("id");
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk1" FOREIGN KEY ("gearbox_id") REFERENCES "gearbox_type"("id");
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk2" FOREIGN KEY ("body_id") REFERENCES "body_type"("id");
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk3" FOREIGN KEY ("drive_id") REFERENCES "drive_type"("id");
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk4" FOREIGN KEY ("wheel_id") REFERENCES "wheel_type"("id");
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk5" FOREIGN KEY ("car_state_id") REFERENCES "car_state"("id");
ALTER TABLE "cars" ADD CONSTRAINT "cars_fk6" FOREIGN KEY ("color_id") REFERENCES "colors"("id");










