-- Express Roleplay - Gaming fresh database schema v0.1
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;

CREATE TABLE IF NOT EXISTS `servercore` (
  `keyname` varchar(64) NOT NULL,
  `value` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`keyname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `servercore` (`keyname`,`value`) VALUES
('ServerName','Express Roleplay - Gaming'),('Website',''),('Discord',''),
('DefaultCash','1000'),('DefaultBank','9000'),
('DefaultSpawnX','1642.18'),('DefaultSpawnY','-2334.90'),('DefaultSpawnZ','13.54'),('DefaultSpawnA','0.0'),('DefaultSpawnInterior','0'),('DefaultSpawnVW','0'),
('DefaultMaleSkin','26'),('DefaultFemaleSkin','12'),
('JobLimitDefault','1'),('VipJobLimit0','1'),('VipJobLimit1','2'),('VipJobLimit2','3'),('VipJobLimit3','4'),('VipJobLimit4','5'),('VipJobLimit5','6'),
('VipHospitalTime0','30'),('VipHospitalTime1','25'),('VipHospitalTime2','20'),('VipHospitalTime3','15'),('VipHospitalTime4','10'),('VipHospitalTime5','5'),
('VipHospitalTransferMinLevel','1'),('DeathHPDecrease','2.0'),('DeathTickMS','5000'),('HospitalRespawnHP','50.0'),('FamilyBackupBeaconTime','120')
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

CREATE TABLE IF NOT EXISTS `default_playerinfo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `field_name` varchar(64) NOT NULL,
  `default_value` varchar(128) NOT NULL,
  PRIMARY KEY (`id`), UNIQUE KEY `field_name` (`field_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(24) NOT NULL,
  `password` varchar(129) NOT NULL,
  `admin` int NOT NULL DEFAULT 0,
  `vip` int NOT NULL DEFAULT 0,
  `level` int NOT NULL DEFAULT 1,
  `playing_hours` int NOT NULL DEFAULT 0,
  `age` int NOT NULL DEFAULT 18,
  `dob` varchar(16) NOT NULL DEFAULT '',
  `gender` int NOT NULL DEFAULT 1,
  `cash` int NOT NULL DEFAULT 1000,
  `bank` int NOT NULL DEFAULT 9000,
  `phone` int NOT NULL DEFAULT 0,
  `phonebook` int NOT NULL DEFAULT 0,
  `phone_off` int NOT NULL DEFAULT 0,
  `has_radio` int NOT NULL DEFAULT 0,
  `radio_freq` int NOT NULL DEFAULT 0,
  `vehicle_lock` int NOT NULL DEFAULT 0,
  `hosp_insurance` int NOT NULL DEFAULT 9999,
  `married_to` varchar(24) NOT NULL DEFAULT '',
  `crimes` int NOT NULL DEFAULT 0,
  `arrests` int NOT NULL DEFAULT 0,
  `wanted_level` int NOT NULL DEFAULT 0,
  `materials` int NOT NULL DEFAULT 0,
  `pot` int NOT NULL DEFAULT 0,
  `crack` int NOT NULL DEFAULT 0,
  `rope` int NOT NULL DEFAULT 0,
  `packages` int NOT NULL DEFAULT 0,
  `seeds` int NOT NULL DEFAULT 0,
  `sprunk` int NOT NULL DEFAULT 0,
  `spraycans` int NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `armor` float NOT NULL DEFAULT 0,
  `respect_points` int NOT NULL DEFAULT 0,
  `warnings` int NOT NULL DEFAULT 0,
  `hospital_time` int NOT NULL DEFAULT 30,
  `tog_free_hospital` int NOT NULL DEFAULT 0,
  `family_id` int NOT NULL DEFAULT -1,
  `family_rank` int NOT NULL DEFAULT 0,
  `family_crew` int NOT NULL DEFAULT 0,
  `business_id` int NOT NULL DEFAULT -1,
  `spawn_x` float NOT NULL DEFAULT 1642.18,
  `spawn_y` float NOT NULL DEFAULT -2334.90,
  `spawn_z` float NOT NULL DEFAULT 13.54,
  `spawn_a` float NOT NULL DEFAULT 0,
  `spawn_int` int NOT NULL DEFAULT 0,
  `spawn_vw` int NOT NULL DEFAULT 0,
  `job0` int NOT NULL DEFAULT 0, `job1` int NOT NULL DEFAULT 0, `job2` int NOT NULL DEFAULT 0, `job3` int NOT NULL DEFAULT 0, `job4` int NOT NULL DEFAULT 0,
  `job5` int NOT NULL DEFAULT 0, `job6` int NOT NULL DEFAULT 0, `job7` int NOT NULL DEFAULT 0, `job8` int NOT NULL DEFAULT 0, `job9` int NOT NULL DEFAULT 0,
  `weapon0` int NOT NULL DEFAULT 0, `weapon1` int NOT NULL DEFAULT 0, `weapon2` int NOT NULL DEFAULT 0, `weapon3` int NOT NULL DEFAULT 0, `weapon4` int NOT NULL DEFAULT 0, `weapon5` int NOT NULL DEFAULT 0, `weapon6` int NOT NULL DEFAULT 0,
  `weapon7` int NOT NULL DEFAULT 0, `weapon8` int NOT NULL DEFAULT 0, `weapon9` int NOT NULL DEFAULT 0, `weapon10` int NOT NULL DEFAULT 0, `weapon11` int NOT NULL DEFAULT 0, `weapon12` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`), UNIQUE KEY `username` (`username`), UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `weapon_material_costs` (`weaponid` int NOT NULL, `weapon_name` varchar(32) NOT NULL, `material_cost` int NOT NULL DEFAULT 0, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`weaponid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `weapon_material_costs` (`weaponid`,`weapon_name`,`material_cost`) VALUES
(22,'Colt 45',100),(23,'Silenced Pistol',150),(24,'Desert Eagle',600),(25,'Shotgun',500),(29,'MP5',400),(30,'AK47',900),(31,'M4',1000),(33,'Rifle',650),(34,'Sniper',1500),(0,'Armor 50',250)
ON DUPLICATE KEY UPDATE `material_cost`=VALUES(`material_cost`);

CREATE TABLE IF NOT EXISTS `hospitals` (
  `id` int NOT NULL AUTO_INCREMENT, `name` varchar(64) NOT NULL, `city` int NOT NULL DEFAULT 0, `city_name` varchar(32) NOT NULL DEFAULT 'Los Santos',
  `insurance_x` float NOT NULL DEFAULT 0, `insurance_y` float NOT NULL DEFAULT 0, `insurance_z` float NOT NULL DEFAULT 0, `insurance_a` float NOT NULL DEFAULT 0, `insurance_int` int NOT NULL DEFAULT 0, `insurance_vw` int NOT NULL DEFAULT 0,
  `ems_x` float NOT NULL DEFAULT 0, `ems_y` float NOT NULL DEFAULT 0, `ems_z` float NOT NULL DEFAULT 0, `ems_a` float NOT NULL DEFAULT 0, `ems_int` int NOT NULL DEFAULT 0, `ems_vw` int NOT NULL DEFAULT 0,
  `safe_x` float NOT NULL DEFAULT 0, `safe_y` float NOT NULL DEFAULT 0, `safe_z` float NOT NULL DEFAULT 0, `safe_a` float NOT NULL DEFAULT 0, `safe_int` int NOT NULL DEFAULT 0, `safe_vw` int NOT NULL DEFAULT 0,
  `hospital_price` int NOT NULL DEFAULT 250, `hospital_price_insured` int NOT NULL DEFAULT 150, `insurance_price` int NOT NULL DEFAULT 1000, `ems_fee` int NOT NULL DEFAULT 120, `ems_fee_insured` int NOT NULL DEFAULT 60, `safe_balance` int NOT NULL DEFAULT 0, `enabled` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `hospital_beds` (`id` int NOT NULL AUTO_INCREMENT, `hospital_id` int NOT NULL, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL, `a` float NOT NULL DEFAULT 0, `interior` int NOT NULL DEFAULT 0, `vw` int NOT NULL DEFAULT 0, PRIMARY KEY (`id`), KEY `hospital_id` (`hospital_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `hospitals` (`id`,`name`,`city`,`city_name`,`insurance_x`,`insurance_y`,`insurance_z`,`insurance_int`,`insurance_vw`,`ems_x`,`ems_y`,`ems_z`,`ems_int`,`ems_vw`,`safe_x`,`safe_y`,`safe_z`,`safe_int`,`safe_vw`,`hospital_price`,`hospital_price_insured`,`insurance_price`,`ems_fee`,`ems_fee_insured`,`enabled`) VALUES
(1,'County General Hospital',0,'Los Santos',2383.0728,2662.0520,8001.1479,1,1001,2380.0,2660.0,8001.1479,1,1001,2385.0,2662.0,8001.1479,1,1001,250,150,1000,120,60,1),
(2,'All Saints General Hospital',0,'Los Santos',2383.0728,2662.0520,8001.1479,1,1002,2380.0,2660.0,8001.1479,1,1002,2385.0,2662.0,8001.1479,1,1002,250,150,1000,120,60,1)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);
INSERT INTO `hospital_beds` (`hospital_id`,`x`,`y`,`z`,`a`,`interior`,`vw`) VALUES
(1,2376.0,2666.0,8001.15,90.0,1,1001),(1,2376.0,2668.0,8001.15,90.0,1,1001),(2,2376.0,2666.0,8001.15,90.0,1,1002),(2,2376.0,2668.0,8001.15,90.0,1,1002);

CREATE TABLE IF NOT EXISTS `audio_streams` (`id` int NOT NULL AUTO_INCREMENT, `name` varchar(64) NOT NULL, `url` varchar(256) NOT NULL, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `audio_streams` (`name`,`url`,`enabled`) VALUES ('Example Stream','http://example.com/stream.mp3',0);

CREATE TABLE IF NOT EXISTS `businesses` (`id` int NOT NULL AUTO_INCREMENT, `name` varchar(64) NOT NULL, `type` int NOT NULL DEFAULT 1, `owner_id` int NOT NULL DEFAULT 0, `price` int NOT NULL DEFAULT 250000, `materials` int NOT NULL DEFAULT 0, `materials_capacity` int NOT NULL DEFAULT 2000, `safe_balance` int NOT NULL DEFAULT 0, `ext_x` float NOT NULL DEFAULT 0, `ext_y` float NOT NULL DEFAULT 0, `ext_z` float NOT NULL DEFAULT 0, `ext_a` float NOT NULL DEFAULT 0, `ext_int` int NOT NULL DEFAULT 0, `ext_vw` int NOT NULL DEFAULT 0, `int_x` float NOT NULL DEFAULT 0, `int_y` float NOT NULL DEFAULT 0, `int_z` float NOT NULL DEFAULT 0, `int_a` float NOT NULL DEFAULT 0, `int_int` int NOT NULL DEFAULT 0, `int_vw` int NOT NULL DEFAULT 0, `safe_x` float NOT NULL DEFAULT 0, `safe_y` float NOT NULL DEFAULT 0, `safe_z` float NOT NULL DEFAULT 0, `safe_a` float NOT NULL DEFAULT 0, `safe_int` int NOT NULL DEFAULT 0, `safe_vw` int NOT NULL DEFAULT 0, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `business_product_catalog` (`id` int NOT NULL AUTO_INCREMENT, `business_type` int NOT NULL, `product_name` varchar(64) NOT NULL, `product_key` varchar(32) NOT NULL, `price` int NOT NULL, `material_cost` int NOT NULL, `default_stock_capacity` int NOT NULL DEFAULT 50, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `business_products` (`id` int NOT NULL AUTO_INCREMENT, `business_id` int NOT NULL, `catalog_id` int NOT NULL, `product_name` varchar(64) NOT NULL, `product_key` varchar(32) NOT NULL, `price` int NOT NULL, `material_cost` int NOT NULL, `stock` int NOT NULL DEFAULT 0, `stock_capacity` int NOT NULL DEFAULT 50, `admin_enabled` tinyint NOT NULL DEFAULT 1, `owner_enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `dealership_vehicles` (`id` int NOT NULL AUTO_INCREMENT, `business_id` int NOT NULL, `veh_modelid` int NOT NULL, `veh_name` varchar(32) NOT NULL, `color1` int NOT NULL DEFAULT 0, `color2` int NOT NULL DEFAULT 0, `x` float NOT NULL DEFAULT 0, `y` float NOT NULL DEFAULT 0, `z` float NOT NULL DEFAULT 0, `a` float NOT NULL DEFAULT 0, `interior` int NOT NULL DEFAULT 0, `vw` int NOT NULL DEFAULT 0, `price` int NOT NULL DEFAULT 0, `material_cost` int NOT NULL DEFAULT 0, `stock` int NOT NULL DEFAULT 0, `stock_capacity` int NOT NULL DEFAULT 10, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `business_product_catalog` (`business_type`,`product_name`,`product_key`,`price`,`material_cost`,`default_stock_capacity`,`enabled`) VALUES
(1,'Phone','phone',500,20,50,1),(1,'Phonebook','phonebook',150,5,50,1),(1,'Radio','radio',300,10,50,1),(1,'Spray Can','spraycan',250,15,50,1),(1,'Rope','rope',100,5,50,1),(1,'Cigarettes','cigarettes',25,1,100,1),(1,'Mask','mask',300,15,50,1),(1,'Dice','dice',50,1,50,1),(1,'Camera','camera',200,10,50,1),(1,'Hotdog Sandwich','hotdog_sandwich',25,2,100,1),(1,'Sprunk','sprunk',15,1,100,1),(1,'Vehicle Lock - Alarm','vehlock_alarm',1000,50,20,1),(1,'Vehicle Lock - Industrial','vehlock_industrial',2500,150,20,1),
(2,'Colt 45','weapon_22',1500,100,20,1),(2,'Silenced Pistol','weapon_23',2500,150,20,1),(2,'MP5','weapon_29',6000,400,10,1),(2,'Armor 50','armor_50',1000,250,20,1),
(7,'Burger','burger',25,2,100,1),(7,'Pizza','pizza',30,3,100,1),(7,'Chicken Meal','chicken_meal',35,3,100,1),(7,'Fries','fries',15,1,100,1),(7,'Coffee','coffee',10,1,100,1),(7,'Water','water',10,1,100,1)
ON DUPLICATE KEY UPDATE `price`=VALUES(`price`);

CREATE TABLE IF NOT EXISTS `families` (`id` int NOT NULL AUTO_INCREMENT, `name` varchar(64) NOT NULL, `leader_id` int NOT NULL DEFAULT 0, `leader_name` varchar(24) NOT NULL DEFAULT 'Nobody', `motd` varchar(128) NOT NULL DEFAULT '', `safe_deposit_rank` int NOT NULL DEFAULT 1, `safe_withdraw_rank` int NOT NULL DEFAULT 6, `locker_deposit_rank` int NOT NULL DEFAULT 1, `locker_withdraw_rank` int NOT NULL DEFAULT 6, `locker_gun_rank` int NOT NULL DEFAULT 1, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `family_ranks` (`id` int NOT NULL AUTO_INCREMENT, `family_id` int NOT NULL, `rank_id` int NOT NULL, `rank_name` varchar(32) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `family_crews` (`id` int NOT NULL AUTO_INCREMENT, `family_id` int NOT NULL, `crew_id` int NOT NULL, `crew_name` varchar(32) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `family_lockers` (`id` int NOT NULL AUTO_INCREMENT, `family_id` int NOT NULL, `x` float NOT NULL DEFAULT 0, `y` float NOT NULL DEFAULT 0, `z` float NOT NULL DEFAULT 0, `interior` int NOT NULL DEFAULT 0, `vw` int NOT NULL DEFAULT 0, `materials` int NOT NULL DEFAULT 10000, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `family_locker_guns` (`id` int NOT NULL AUTO_INCREMENT, `locker_id` int NOT NULL, `weaponid` int NOT NULL, `admin_enabled` tinyint NOT NULL DEFAULT 1, `leader_enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `family_safes` (`id` int NOT NULL AUTO_INCREMENT, `family_id` int NOT NULL, `x` float NOT NULL DEFAULT 0, `y` float NOT NULL DEFAULT 0, `z` float NOT NULL DEFAULT 0, `interior` int NOT NULL DEFAULT 0, `vw` int NOT NULL DEFAULT 0, `balance` int NOT NULL DEFAULT 0, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vehicles` (`id` int NOT NULL AUTO_INCREMENT, `owner_pid` int NOT NULL DEFAULT 0, `family_id` int NOT NULL DEFAULT -1, `faction_id` int NOT NULL DEFAULT -1, `model` int NOT NULL, `color1` int NOT NULL DEFAULT 0, `color2` int NOT NULL DEFAULT 0, `x` float NOT NULL DEFAULT 0, `y` float NOT NULL DEFAULT 0, `z` float NOT NULL DEFAULT 0, `a` float NOT NULL DEFAULT 0, `interior` int NOT NULL DEFAULT 0, `vw` int NOT NULL DEFAULT 0, `lock_type` int NOT NULL DEFAULT 0, `health` float NOT NULL DEFAULT 1000, `enabled` tinyint NOT NULL DEFAULT 1, PRIMARY KEY (`id`), KEY `owner_pid` (`owner_pid`), KEY `family_id` (`family_id`), KEY `faction_id` (`faction_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;
