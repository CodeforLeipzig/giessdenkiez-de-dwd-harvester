
-- this is taken from the AWS docs
-- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS
create extension postgis;
create extension fuzzystrmatch;
create extension postgis_tiger_geocoder;
create extension postgis_topology;

alter schema tiger owner to postgres;
alter schema tiger_data owner to postgres;
alter schema topology owner to postgres;

CREATE FUNCTION exec(text) returns text language plpgsql volatile AS $f$ BEGIN EXECUTE $1; RETURN $1; END; $f$;

SELECT exec('ALTER TABLE ' || quote_ident(s.nspname) || '.' || quote_ident(s.relname) || ' OWNER TO postgres;')
  FROM (
    SELECT nspname, relname
    FROM pg_class c JOIN pg_namespace n ON (c.relnamespace = n.oid)
    WHERE nspname in ('tiger','topology') AND
    relkind IN ('r','S','v') ORDER BY relkind = 'S')
s;


-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS radolan_harvester_id_seq;

-- Table Definition
CREATE TABLE "public"."radolan_harvester" (
    "id" int4 NOT NULL DEFAULT nextval('radolan_harvester_id_seq'::regclass),
    "collection_date" date,
    "start_date" timestamp,
    "end_date" timestamp,
    PRIMARY KEY ("id")
);

CREATE SEQUENCE IF NOT EXISTS radolan_geometry_id_seq;

-- Table Definition
CREATE TABLE "public"."radolan_geometry" (
    "id" int4 NOT NULL DEFAULT nextval('radolan_geometry_id_seq'::regclass),
    "geometry" geometry,
    "centroid" geometry,
    PRIMARY KEY ("id")
);

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS radolan_temp_id_seq;

-- Table Definition
CREATE TABLE "public"."radolan_temp" (
    "id" int4 NOT NULL DEFAULT nextval('radolan_temp_id_seq'::regclass),
    "geometry" geometry,
    "value" int2,
    "measured_at" timestamp,
    PRIMARY KEY ("id")
);


-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS trees_watered_id_seq;

-- Table Definition
CREATE TABLE "public"."trees_watered" (
    "id" text NOT NULL DEFAULT nextval('trees_watered_id_seq'::regclass),
    "watered" _text DEFAULT '{}'::text[],
    PRIMARY KEY ("id")
);
CREATE TABLE "public"."trees" (
    "id" text NOT NULL,
    "lat" text,
    "lng" text,
    "artDtsch" text,
    "artBot" text,
    "gattungDeutsch" text,
    "gattung" text,
    "standortNr" text,
    "strName" text,
    "hausNr" text,
    "zusatz" text,
    "pflanzjahr" text,
    "standAlter" text,
    "kroneDurch" text,
    "stammUmfg" text,
    "type" text,
    "baumHoehe" text,
    "bezirk" text,
    "eigentuemer" text,
    "adopted" text,
    "watered" text,
    "radolan_sum" int4,
    "radolan_days" _int4,
    "geom" geometry,
    PRIMARY KEY ("id")
);
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS radolan_data_id_seq;

-- Table Definition
CREATE TABLE "public"."radolan_data" (
    "id" int4 NOT NULL DEFAULT nextval('radolan_data_id_seq'::regclass),
    "measured_at" timestamp,
    "value" int2,
    "geom_id" int2,
    PRIMARY KEY ("id")
);

INSERT INTO public.radolan_geometry("id", "geometry", "centroid") VALUES 
("9047","0106000020E61000000100000001030000000100000005000000B13385CE6BCC28400E10CCD1E3AB49406C26DF6C73D328400EF3E505D8AB4940FB05BB61DBD22840BD8C62B9A5A94940CF6BEC12D5CB2840BDA94885B1A94940B13385CE6BCC28400E10CCD1E3AB4940","0101000020E6100000EC2FF2EEA3CF2840C7D44FCEC4AA4940");

INSERT INTO public.trees("id", "standortNr", "strName", "bezirk", "artBot", "artDtsch", "pflanzjahr", "lat", "lng", "geom", "radolan_sum", "watered", "adopted", "radolan_days") VALUES
('id-28504','5707','Dresdner Straße','Zentrum-Südost','Tilia cordata "Greenspire"','Stadt-Linde','2006','12.389458822358371','51.338328845651709','0101000020E6100000F455922567C728400BAF0F5C4EAB4940',NULL,NULL,NULL,NULL);

INSERT INTO "public"."radolan_harvester" ("id", "collection_date", "start_date", "end_date") VALUES
('1', '2020-03-29', '2020-02-29 00:50:00', '2020-03-29 23:50:00');