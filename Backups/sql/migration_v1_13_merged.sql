-- ERP v1.13 merged migration
-- Includes vehicle editor/faction foundation updates from the merged build.
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `paintjob` int NOT NULL DEFAULT -1 AFTER `color2`;
ALTER TABLE `vehicles` MODIFY `owner_pid` int NOT NULL DEFAULT 0;
ALTER TABLE `vehicles` MODIFY `family_id` int NOT NULL DEFAULT 0;
ALTER TABLE `vehicles` MODIFY `faction_id` int NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `factions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `leader_id` int NOT NULL DEFAULT 0,
  `leader_name` varchar(24) NOT NULL DEFAULT 'Nobody',
  `motd` varchar(128) NOT NULL DEFAULT '',
  `safe_balance` int NOT NULL DEFAULT 0,
  `enabled` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
