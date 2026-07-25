-- ExpressRP migration: NGRP-style tutorial/register additions
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `tutorial` int NOT NULL DEFAULT 0 AFTER `password`;
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `accent` int NOT NULL DEFAULT 0 AFTER `gender`;
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `skin` int NOT NULL DEFAULT 26 AFTER `accent`;

INSERT INTO `servercore` (`keyname`,`value`) VALUES
('TutorialEnabled','1'),
('AllowSkipTutorial','1'),
('DefaultSpawnX','1715.0687'),
('DefaultSpawnY','-1899.5597'),
('DefaultSpawnZ','13.5665'),
('DefaultSpawnA','0.0'),
('DefaultSpawnInterior','0'),
('DefaultSpawnVW','0')
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);
