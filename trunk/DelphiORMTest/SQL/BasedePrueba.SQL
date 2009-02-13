CREATE TABLE "TipoDomicilio" (
    "TipoDomicilioID" INTEGER NOT NULL,
    "Descripcion" VARCHAR(50),
    "DescripcionReducida" VARCHAR(30),
    "Observaciones" VARCHAR(100));

alter table "TipoDomicilio" add constraint "PK_TipoDomicilio" primary key ("TipoDomicilioID");

CREATE TABLE "TipoDocumento" (
    "TipoDocumentoID" INTEGER NOT NULL,
    "Descripcion" VARCHAR(50),
    "DescripcionReducida" VARCHAR(20),
    "Observaciones" VARCHAR(100));

alter table "TipoDocumento" add constraint "PK_TipoDocumento" primary key ("TipoDocumentoID");

CREATE TABLE "Persona" (
    "PerdonaID" INTEGER NOT NULL,
    "Apellido" VARCHAR(50),
    "Nombre" VARCHAR(50),
    "TipoDocumentoID" INTEGER,
    "NumeroDocumento" INTEGER);

alter table "Persona" add constraint "PK_Persona" primary key ("PerdonaID");
alter table "Persona" add constraint "FK_Persona_1" foreign key ("TipoDocumentoID") references "TipoDocumento"("TipoDocumentoID");


CREATE TABLE "Domicilio" (
    "DomicilioID" INTEGER NOT NULL,
    "TipoDomicilioID" INTEGER,
    "PersonaID" INTEGER,
    "Calle" VARCHAR(50),
    "Numero" INTEGER);
alter table "Domicilio" add constraint "PK_Domicilio" primary key ("DomicilioID");

ALTER TABLE "Domicilio" ADD CONSTRAINT "FK_Domicilio_1" FOREIGN KEY ("TipoDomicilioID") REFERENCES "TipoDomicilio" ("TipoDomicilioID");
ALTER TABLE "Domicilio" ADD CONSTRAINT "FK_Domicilio_2" FOREIGN KEY ("PersonaID") REFERENCES "Persona" ("PerdonaID");

CREATE GENERATOR "Domicilio"
CREATE GENERATOR "Persona"
CREATE GENERATOR "TipoDocumento"
CREATE GENERATOR "TipoDomicilio"
