-- ExpressRP migration: character country, default phone/family IDs, spawn and display support
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `tutorial` int NOT NULL DEFAULT 0 AFTER `password`;
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `country` varchar(32) NOT NULL DEFAULT 'Unknown' AFTER `dob`;
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `accent` int NOT NULL DEFAULT 0 AFTER `gender`;
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `skin` int NOT NULL DEFAULT 26 AFTER `accent`;

ALTER TABLE `accounts` MODIFY `phone` int NOT NULL DEFAULT 0;
ALTER TABLE `accounts` MODIFY `family_id` int NOT NULL DEFAULT 0;
ALTER TABLE `accounts` MODIFY `business_id` int NOT NULL DEFAULT 0;
ALTER TABLE `vehicles` MODIFY `family_id` int NOT NULL DEFAULT 0;
ALTER TABLE `vehicles` MODIFY `faction_id` int NOT NULL DEFAULT 0;

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

UPDATE `servercore` SET `value`='1715.0687' WHERE `keyname`='DefaultSpawnX';
UPDATE `servercore` SET `value`='-1899.5597' WHERE `keyname`='DefaultSpawnY';
UPDATE `servercore` SET `value`='13.5665' WHERE `keyname`='DefaultSpawnZ';
UPDATE `servercore` SET `value`='0.0' WHERE `keyname`='DefaultSpawnA';
