-- HUE - 直客-CPC， 手工API， 直客CPA
SELECT
	dt,
	country, 
	new_src,
	CAST (
		ROUND(SUM(revenue), 3) AS string
	) AS revenue
FROM
	(
		SELECT
			dt,
			country, 
			CASE
		WHEN src = 80
		AND bidtype = 3 THEN
			"直客-cpc"		
		WHEN src IN (3, 80)
		AND bidtype = 1 THEN
			"直客-cpa"
		END AS new_src,
		SUM (revenue) AS revenue
	FROM
		detail_report
	WHERE
		dt >= "20150816" and dt <= '20150822'
	AND expid = "*"
	AND media_id NOT IN (113)
	AND posid NOT IN (
		104102,
		104104,
		104105,
		104106,
		104107,
		104108,
		104109,
		104110,
		104111,
		104112,
		104116,
		104117,
		104118,
		104119
	)
	GROUP BY
		dt,
		country,
		src,
		bidtype
	) T
WHERE
	new_src IS NOT NULL and revenue > 0 and length(country) < 5
GROUP BY
	dt,
	country,
	new_src

-- HUE - API
SELECT
	dt,
	country,
	new_src,
	CAST (
		round(SUM(revenue), 3) AS string
	) AS Revenue
FROM
	(
		SELECT
			dt,
			country,
			CASE
		WHEN src IN (5) THEN
			"LeadBolt"
		WHEN src IN (35) THEN
			"youappi"
		WHEN src IN (25) THEN
			"taptical"
		WHEN src IN (38) THEN
			"tabatoo"
		WHEN src IN (26) THEN
			"supersonic"
		WHEN src IN (21) THEN
			"mobvista"
		WHEN src IN (36) THEN
			"mobpartner-off"
		WHEN src IN (1002, 41) THEN
			"appsfire-offline"
		WHEN src IN (31) THEN
			"appnext"
		WHEN src IN (29) THEN
			"apploop"
		WHEN src IN (33) THEN
			"appcoach"
		WHEN src IN (39) THEN
			"startapp-off"
		WHEN src IN (23) THEN
			"appia-offline"
		WHEN src IN (6) THEN
			"AppLift"
		WHEN src IN (27) THEN
			"glispa"
		WHEN src IN (28) THEN
			"motive"
		WHEN src IN (22) THEN
			"ironsource"
		WHEN src IN (37) THEN
			"raftika-off"
		WHEN src IN (2) THEN
			"appia"
		WHEN src IN (40) THEN
			"applovin"
		END AS new_src,
		SUM (revenue) AS revenue
	FROM
		detail_report
	WHERE
		revenue > 0 and length(country) < 5 and dt >= "20150819" and dt <= '20150822'
	AND expid = "*"
	AND posid NOT IN (
		104102,
		104104,
		104105,
		104106,
		104107,
		104108,
		104109,
		104110,
		104111,
		104112,
		104116,
		104117,
		104118,
		104119
	)
	GROUP BY
		dt,
		country,
		src
	) T
WHERE
	new_src IS NOT NULL
GROUP BY
	dt,
	country,
	new_src

-- Facebook & AdMob
SELECT
	date,
	datatable.country, 
	'facebook' AS src,
	sum(datatable.earnings) AS Revenue

FROM
	admob_facebook_country datatable
WHERE
	datatable.date >= '2015-08-16' and datatable.date <= '2015-08-22'
GROUP BY
	datatable.date,
	datatable.country
UNION ALL
	SELECT
		DATE,
		country_code, 
		"admob",
	SUM(earnings) / 7.75 AS Revenue
FROM
	`admob_data`
WHERE
	`date` >= '2015-08-16' and `date` <= '2015-08-22' and application <> '其他' 
GROUP BY
	DATE,
	country_code

-- CPM & Video
SET @dt := '2015-08-10';

SELECT
	*
FROM
	(
		SELECT
			date,
			appName,
			'videos' AS src,
			CASE
		WHEN appName = 'Photo Grid－Collage Maker' THEN
			'PG_Android'
		END AS Pos,
		SUM(impressions),
		SUM(earnings),

	IF (
		SUM(impressions) > 0,
		round(
			SUM(earnings) * 1000 / SUM(impressions),
			4
		),
		"PV为0"
	) AS `eCPM`,

IF (
	SUM(impressions) > 0,
	round(
		SUM(clicks) / SUM(impressions),
		4
	),
	"PV为0"
) AS `CTR`,

IF (
	SUM(clicks) > 0,
	round(
		SUM(earnings) / SUM(clicks),
		4
	),
	"Click为0"
) AS `ePC`,
 SUM(clicks) AS clicks
FROM
	adcolony_info_out
WHERE
	date = @dt and 1=1
GROUP BY
	date,
	appName
UNION ALL
	SELECT
		date,
		pkgName,
		'CPM' AS src,
		CASE
	WHEN pkgname = 'com.cleanmaster.mguard' THEN
		'CM_结果页'
	WHEN pkgname = 'com.cleanmaster.security' THEN
		'CMS_结果页'
	WHEN pkgname = 'com.ijinshan.kbatterydoctor' THEN
		'BD_结果页'
	WHEN pkgname = 'com.roidapp.photogrid' THEN
		'PG_Android'
	END AS Pos,
	SUM(impressions) AS impression,
	SUM(revenue) AS revenue,

IF (
	SUM(impressions) > 0,
	round(
		SUM(revenue) * 1000 / SUM(impressions),
		4
	),
	"PV为0"
) AS `eCPM`,

IF (
	SUM(impressions) > 0,
	round(
		SUM(clicks) / SUM(impressions),
		4
	),
	"PV为0"
) AS `CTR`,

IF (
	SUM(clicks) > 0,
	round(SUM(revenue) / SUM(clicks), 4),
	"Click为0"
) AS `ePC`,
 SUM(clicks) AS clicks
FROM
	applovin_info_out
WHERE
	date >= @dt
GROUP BY
	date,
	pkgName
	) t
WHERE
	Pos IS NOT NULL

-- CML MobPartner
-- http://reportapiv2.mobpartner.mobi/report2.php?date_type=daily&date_begin=20150401&date_end=20180415&target=&value_trx_notrefused=1&value_trx_notrefused_total=1&order=date&desc=1&default_values=0&display_name=1&login=cheetahmobile&key=aG_4gF19zeo&date_ref=trx&total=1&download=0&display_name=1&date_format=2&change_libelle=1&format=csv

-- RTB 
-- https://docs.google.com/spreadsheets/d/1OI8GrKQA17dAaMFuyiAEgiO8sQnR-REfnFth1MnIl00/edit#gid=1952207532

