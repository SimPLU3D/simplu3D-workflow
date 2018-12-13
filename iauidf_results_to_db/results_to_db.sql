CREATE TABLE IF NOT EXISTS public.simuls_sdp
(
  directory integer,
  idpar character varying,
  numberofobjects integer,
  sdp numeric,
  iterations integer,
  run character varying
);

CREATE TABLE IF NOT EXISTS public.simuls_errors
(
  directory integer,
  run character varying
);
