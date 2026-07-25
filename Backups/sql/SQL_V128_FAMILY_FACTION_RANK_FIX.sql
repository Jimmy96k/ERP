-- ERP v1.28 Family/Faction Membership Rank Fix

ALTER TABLE `accounts`
ADD COLUMN IF NOT EXISTS `family_id` INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS `faction_id` INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS `family_rank` INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS `family_crew` INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS `faction_rank` INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS `faction_division` INT NOT NULL DEFAULT 0;

-- Normalize old empty/null style values.
UPDATE `accounts` SET `family_id`=0 WHERE `family_id` IS NULL;
UPDATE `accounts` SET `faction_id`=0 WHERE `faction_id` IS NULL;
UPDATE `accounts` SET `family_rank`=0 WHERE `family_id`=0;
UPDATE `accounts` SET `family_crew`=0 WHERE `family_id`=0;
UPDATE `accounts` SET `faction_rank`=0 WHERE `faction_id`=0;
UPDATE `accounts` SET `faction_division`=0 WHERE `faction_id`=0;

-- Existing leaders in family/faction tables become rank 6 in their accounts.
UPDATE `accounts` a
JOIN `families` f ON f.`leader_id` = a.`id`
SET a.`family_id` = f.`id`, a.`family_rank` = 6, a.`family_crew` = 0
WHERE f.`leader_id` > 0;

UPDATE `accounts` a
JOIN `factions` f ON f.`leader_id` = a.`id`
SET a.`faction_id` = f.`id`, a.`faction_rank` = 6, a.`faction_division` = 0
WHERE f.`leader_id` > 0;
