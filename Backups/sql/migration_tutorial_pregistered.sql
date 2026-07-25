-- ExpressRP migration: tutorial + ServerCore tutorial settings
ALTER TABLE `accounts` ADD COLUMN IF NOT EXISTS `tutorial` int NOT NULL DEFAULT 0 AFTER `password`;

INSERT INTO `servercore` (`keyname`,`value`) VALUES
('TutorialEnabled','1'),
('AllowSkipTutorial','1')
ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);
