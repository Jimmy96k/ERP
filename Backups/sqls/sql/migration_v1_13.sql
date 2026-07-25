-- ERP v1.13 migration: vehicle editor paintjob
ALTER TABLE `vehicles` ADD COLUMN IF NOT EXISTS `paintjob` int NOT NULL DEFAULT -1 AFTER `color2`;
ALTER TABLE `vehicles` MODIFY `owner_pid` int NOT NULL DEFAULT 0;
ALTER TABLE `vehicles` MODIFY `family_id` int NOT NULL DEFAULT 0;
ALTER TABLE `vehicles` MODIFY `faction_id` int NOT NULL DEFAULT 0;
