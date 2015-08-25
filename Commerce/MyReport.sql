-- HUE - 直客-CPC， 手工API， 直客CPA
SELECT
	dt,
	country,
	new_posid,
	new_src,
	sum(pv) AS Impression,
	sum(revenue) AS Revenue,

IF (
	sum(pv) > 0,
	round(
		sum(revenue) * 1000 / sum(pv),
		4
	),
	"PV为0"
) AS eCPM,

IF (
	sum(pv) > 0,
	round(sum(clk) / sum(pv), 4),
	"PV为0"
) AS CTR,

IF (
	sum(clk) > 0,
	round(sum(revenue) / sum(clk), 4),
	"Click为0"
) AS ePC,
 sum(clk) AS Click,

IF (
	sum(clk) > 0,
	round(sum(conversion) / sum(clk), 4),
	"Click为0"
) AS CVR,

IF (
	sum(conversion) > 0,
	round(
		sum(revenue) / sum(conversion),
		4
	),
	"转化为0"
) AS Bid
FROM
	(
		SELECT
			dt,
			country, 
			CASE
		WHEN media_id IN (101, 104)
		AND posid IN (
			4011,
			4201,
			4012,
			4202,
			4013,
			4203,
			4206,
			4207,
			4,
			4004,
			4010
		) THEN
			"CM_结果页"
		WHEN media_id IN (101, 104)
		AND posid IN (1, 6, 11, 12, 28) THEN
			"CM_Picks"
		WHEN media_id IN (104)
		AND posid IN (3002, 3003, 3004) THEN
			"CM_卸载页"
		WHEN media_id IN (104, 105, 110)
		AND posid IN (15, 33, 15000, 110100) THEN
			"CM_游戏盒子"
		WHEN media_id IN (104)
		AND posid IN (
			19001,
			19002,
			19003,
			19004,
			19005,
			19006,
			19007,
			19008,
			19009,
			19010
		) THEN
			"CM_APP_box"
		WHEN media_id IN (205)
		AND posid IN (7005, 7006) THEN
			"CMS_结果页"
		WHEN media_id IN (201)
		AND posid IN (6004, 6010) THEN
			"BD_结果页"
		WHEN media_id IN (201)
		AND posid IN (5014) THEN
			"BD_首页"
		WHEN media_id IN (209) THEN
			"PG_Android"
		WHEN media_id IN (301) THEN
			"CM Launcher"
		WHEN media_id IN (210, 1018) THEN
			"FM"
		WHEN media_id IN (1001) THEN
			"cm flashlight"
		WHEN media_id IN (1043) THEN
			"cm Locker"
		WHEN media_id IN (201)
		AND posid IN (5017, 201101) THEN
			"BD_充电屏保"
		WHEN media_id IN (104)
		AND posid IN (100000) THEN
			"CM_充电屏保"
		WHEN media_id IN (205)
		AND posid IN (100001) THEN
			"CMS_充电屏保"
		WHEN media_id IN (104)
		AND posid IN (104183) THEN
			"CM_天气"
		WHEN media_id IN (205)
		AND posid IN (205104) THEN
			"CMS_天气"
		ELSE
			'Other'
		END AS new_posid,
		CASE
	WHEN src = 80
	AND bidtype = 3
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
	) THEN
		"直客-cpc"
	WHEN src IN (3, 80)
	AND bidtype = 1
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
	) THEN
		"直客-cpa"
	WHEN media_id IN (113)
	THEN '联运收入'  
	ELSE
		"Other"
	END AS new_src,
	sum(impressions_count) AS pv,
	sum(clicks_count) AS clk,
	sum(revenue) AS revenue,
	sum(installs_count) AS conversion
FROM
	detail_report
WHERE
	revenue > 0 and length(country) < 5 and dt >= "20150816" and dt <= '20150818'
AND expid = "*"
AND src NOT IN (500, 501, 3000, 3001, 10001)
AND pkgname NOT IN (
	"com.cpm.mdotm",
	"com.cpm.applovin",
	"com.cpm.loopme",
	"com.cpm.vserv"
)
GROUP BY
	dt,
	country,
	media_id,
	posid,
	src,
	bidtype,
	expid
	) T
WHERE
	new_posid IS NOT NULL
GROUP BY
	dt,
	country,
	new_posid,
	new_src
ORDER BY
	new_posid DESC

-- HUE - API
SELECT
	dt,
	country,
	new_posid,
	new_src,
	sum(pv) AS Impression,
	sum(revenue) AS Revenue,

IF (
	sum(pv) > 0,
	round(
		sum(revenue) * 1000 / sum(pv),
		4
	),
	"PV为0"
) AS eCPM,

IF (
	sum(pv) > 0,
	round(sum(clk) / sum(pv), 4),
	"PV为0"
) AS CTR,

IF (
	sum(clk) > 0,
	round(sum(revenue) / sum(clk), 4),
	"Click为0"
) AS ePC,
 sum(clk) AS Click,

IF (
	sum(clk) > 0,
	round(sum(conversion) / sum(clk), 4),
	"Click为0"
) AS CVR,

IF (
	sum(conversion) > 0,
	round(
		sum(revenue) / sum(conversion),
		4
	),
	"转化为0"
) AS Bid
FROM
	(
		SELECT
			dt,
			country,
			CASE
		WHEN media_id IN (101, 104)
		AND posid IN (
			4011,
			4201,
			4012,
			4202,
			4013,
			4203,
			4206,
			4207,
			4,
			4004,
			4010
		) THEN
			"CM_结果页"
		WHEN media_id IN (101, 104)
		AND posid IN (1, 6, 11, 12, 28) THEN
			"CM_Picks"
		WHEN media_id IN (104)
		AND posid IN (3002, 3003, 3004) THEN
			"CM_卸载页"
		WHEN media_id IN (104, 105, 110)
		AND posid IN (15, 33, 15000, 110100) THEN
			"CM_游戏盒子"
		WHEN media_id IN (104)
		AND posid IN (
			19001,
			19002,
			19003,
			19004,
			19005,
			19006,
			19007,
			19008,
			19009,
			19010
		) THEN
			"CM_APP_box"
		WHEN media_id IN (205)
		AND posid IN (7005, 7006) THEN
			"CMS_结果页"
		WHEN media_id IN (201)
		AND posid IN (6004, 6010) THEN
			"BD_结果页"
		WHEN media_id IN (201)
		AND posid IN (5014) THEN
			"BD_首页"
		WHEN media_id IN (209) THEN
			"PG_Android"
		WHEN media_id IN (301) THEN
			"CM Launcher"
		WHEN media_id IN (210, 1018) THEN
			"FM"
		WHEN media_id IN (1001) THEN
			"cm flashlight"
		WHEN media_id IN (1043) THEN
			"cm Locker"
		WHEN media_id IN (201)
		AND posid IN (5017, 201101) THEN
			"BD_充电屏保"
		WHEN media_id IN (104)
		AND posid IN (100000) THEN
			"CM_充电屏保"
		WHEN media_id IN (205)
		AND posid IN (100001) THEN
			"CMS_充电屏保"
		WHEN media_id IN (104)
		AND posid IN (104183) THEN
			"CM_天气"
		WHEN media_id IN (205)
		AND posid IN (205104) THEN
			"CMS_天气"
		ELSE
			posid
		END AS new_posid,
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
		sum(impressions_count) AS pv,
		sum(clicks_count) AS clk,
		sum(revenue) AS revenue,
		sum(installs_count) AS conversion
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
		media_id,
		posid,
		src
	) T
WHERE
	new_src IS NOT NULL
GROUP BY
	dt,
	country,
	new_posid,
	new_src

-- Facebook & AdMob
SELECT
	date,
	datatable.country, 
	datatable.app_name, 
	'', 
	'facebook' AS src,
	sum(datatable.ad_impressions) as Impression,
	sum(datatable.earnings) AS Revenue

FROM
	admob_facebook_country datatable
WHERE
	datatable.date >= '2015-08-16' and datatable.date <= '2015-08-22'
GROUP BY
	date,
	datatable.country, 
	datatable.app_name 
UNION ALL
	SELECT
		DATE,
		country_code, 
		application,
		'',
		"admob",
	sum(page_views) as Impression, 
	SUM(earnings) / 7.75 AS Revenue
FROM
	`admob_data`
WHERE
	`date` >= '2015-08-16' and `date` <= '2015-08-22' and application <> '其他' 
GROUP BY
	DATE,
	country_code,
	application

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

-- 功能UV和功能PV
SELECT
`day`,
country,
'CleanMaster', 
fuv,
fpv
FROM
ks_business_cmforg
where `day` >= '20150816' and `day` <= '20150822' 
union all
SELECT
`day`,
country,
'CMSecurity', 
fuv,
fpv
FROM
ks_business_cms
where `day` >= '20150816' and `day` <= '20150822' 
union all
SELECT
`day`,
country,
'BatteryDoctor', 
fuv,
fpv
FROM
ks_business_cmbdforg
where `day` >= '20150816' and `day` <= '20150822' 
