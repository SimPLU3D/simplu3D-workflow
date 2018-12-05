CREATE INDEX idx_regles ON regles USING GIST ( geom );
CREATE INDEX idx_parcels ON parcels USING GIST ( geom );
CREATE INDEX idx_mos ON mos USING GIST ( geom );
CREATE INDEX idx_amenagement ON amenagement USING GIST ( geom );

create table parcelles_rulez as (
	SELECT distinct on (p.gid) p.gid pid, r.gid rid,
	idpar,
	libelle_zo,
	date_dul_1 date_dul,
	libelle_de,
	libelle__1,
	cast(b1_fonct as integer) FONCTIONS,
	cast(b1_top_zac as integer) TOP_ZAC,
	b2_top_zac TOP_ZAC2,
	cast(b1_bande as integer) BANDE1,
	cast(b2_t_bande as integer) TYP_BANDE2,
	b2_bande BANDE2,
	cast(b1_t_bande as integer) TYP_BANDE1,
	b1_art_5 ART_51,
	b1_art_6 ART_61,
	cast(b1_art_71 as integer) ART_711,
	b1_art_72 ART_721,
	b1_art_73 ART_731,
	cast(b1_art_74 as integer) ART_741,
	b1_art_8 ART_81,
	b1_art_9 ART_91,
	cast(b1_art_10t as integer) ART_10_TOP,
	b1_art_10 ART_101,
	b1_art_12 ART_121,
	b1_art_13 ART_131,
	b1_art_14 ART_141,
	b2_art_5 ART_52,
	b2_art_6 ART_62,
	cast(b2_art_71 as integer) ART_712,
	b2_art_72 ART_722,
	b2_art_73 ART_732,
	cast(b2_art_74 as integer) ART_742,
	b2_art_8 ART_82,
	b2_art_9 ART_92,
	cast(b2_art_10t as integer) ART_10_T_1,
	b2_art_10 ART_102,
	b2_art_12 ART_122,
	b2_art_13 ART_132,
	b2_art_14 ART_142,
	cast (insee as integer) INSEE,
	object_id,
	dep,
	annee,
	statut_dul,
	b1_haut_m,
	b2_haut_m,
	b1_haut_mt,
	b1_art_9_t,
	cast(b1_zon_cor as integer) CORRECTION,
	cast(b2_fonct as integer) FONCTIONS2,
	b2_zon_cor,
	1 AS ZONAGE_COH,
	1 as simul,    
	st_area(ST_INTERSECTION(r.geom, p.geom)) as aire_intersectee,
	p.geom
	FROM regles r, parcels p
	WHERE ST_Intersects(r.geom, p.geom)
	ORDER BY pid, aire_intersectee DESC
);

CREATE INDEX idx_parcelles_rulez ON parcelles_rulez USING GIST ( geom );

ALTER TABLE public.parcelles_rulez
   ADD COLUMN mos2012 integer;

update parcelles_rulez
set mos2012 = 0;

update parcelles_rulez p
set mos2012 = (
		SELECT mos2012 from mos m
		where st_intersects(p.geom, m.geom) and st_area(st_intersection(p.geom, m.geom)) > 1
		ORDER BY st_area(st_intersection(p.geom, m.geom)) DESC
		LIMIT 1
		);

update parcelles_rulez
set simul = 0
where pid in (
	select p.pid
	from parcelles_rulez p, amenagement a
	where st_intersects(p.geom, a.geom) and a.etat_lib like 'en cours'
);

UPDATE parcelles_rulez SET simul = 0
WHERE ST_AREA(geom) >= 5000 OR ST_AREA(geom) <= 50 ;
