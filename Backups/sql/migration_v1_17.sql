-- ERP v1.17 migration: family/faction editor saving + vehicle ownership/park
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `faction_id` int NOT NULL DEFAULT 0 AFTER `family_id`;

ALTER TABLE `factions`
  ADD COLUMN IF NOT EXISTS `safe_deposit_rank` int NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `safe_withdraw_rank` int NOT NULL DEFAULT 6,
  ADD COLUMN IF NOT EXISTS `locker_deposit_rank` int NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `locker_withdraw_rank` int NOT NULL DEFAULT 6,
  ADD COLUMN IF NOT EXISTS `locker_gun_rank` int NOT NULL DEFAULT 1;

CREATE TABLE IF NOT EXISTS `faction_ranks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faction_id` int NOT NULL,
  `rank_id` int NOT NULL,
  `rank_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `faction_divisions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faction_id` int NOT NULL,
  `division_id` int NOT NULL,
  `division_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `faction_lockers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faction_id` int NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int NOT NULL DEFAULT 0,
  `vw` int NOT NULL DEFAULT 0,
  `materials` int NOT NULL DEFAULT 0,
  `enabled` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `faction_locker_guns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `locker_id` int NOT NULL,
  `weaponid` int NOT NULL,
  `admin_enabled` int NOT NULL DEFAULT 1,
  `leader_enabled` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `faction_safes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `faction_id` int NOT NULL,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int NOT NULL DEFAULT 0,
  `vw` int NOT NULL DEFAULT 0,
  `balance` int NOT NULL DEFAULT 0,
  `enabled` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `family_crews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `family_id` int NOT NULL,
  `crew_id` int NOT NULL,
  `crew_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
